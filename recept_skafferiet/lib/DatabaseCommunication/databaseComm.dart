//Dart mongo pakcage: https://pub.dev/packages/mongo_dart
import 'dart:convert';
import "dart:math";
import 'package:crypto/crypto.dart';
import "package:mongo_dart/mongo_dart.dart";
import "package:recept_skafferiet/recipe.dart";
import "package:uuid/uuid.dart";
import 'dart:io' show Platform;

String host = Platform.environment['MONGO_DART_DRIVER_HOST'] ??
    '10.0.2.2'; //local connection only
String port = Platform.environment['MONGO_DART_DRIVER_PORT'] ??
    '27017'; //local connection only
main() async {
  print("Starting");
  var dbComm = new DatabaseComm();
  await dbComm.connectToCollections();
  print('Connected');
  print(await dbComm.login("Tom", "123"));
}

class DatabaseComm {
  final String uri = "mongodb://$host:$port/ReceptSkafferiet";
  final db = Db("mongodb://$host:$port/ReceptSkafferiet");
  final secretSalt = "VS/Sj3QMIHwUExeHXejcw717hrc49ckXlg+raLH2kA8=";

  DbCollection recipeCollection;
  DbCollection userCollection;
  DbCollection relationalCollection;
  DbCollection userSessions;

  connectToCollections() async {
    print('Connecting');
    await db.open();
    this.recipeCollection = await db.collection('Recipes');
    this.userCollection = await db.collection('Users');
    this.relationalCollection = await db.collection('Relational');
    this.userSessions = await db.collection('UserSessions');
    print("Connected to the Collections succesfully");
  }

  //Gets all recipes connected to a specific user. Takes the specific users id as argument and returns a list of all recipes
  Future<List<Recipe>> getRecipeIds(localUser) async {
    var relations =
        await this.recipeCollection.find({'user_id': localUser}).toList();
    List<Recipe> recipes = [];
    for (var relation in relations) {
      print(relation);
      var recipe =
          await this.recipeCollection.findOne({'_id': relation['recept_id']});

      recipes.add(new Recipe(
          recipe['ingredients'],
          recipe['instructions'],
          recipe['title'],
          recipe['extra'],
          recipe['url'],
          recipe['portions'],
          recipe['image']));
    }
    return recipes;
  }

  //Push recipe
  void pushRecipeClass(localUser, Recipe recipe) async {
    await this.recipeCollection.insert({
      '_id': recipe.url,
      'title': recipe.title,
      'ingredients': recipe.ingredients,
      'instructions': recipe.instructions,
      'extra': recipe.extra,
      'portions': recipe.portions,
      'image': recipe.image
    });
  }

  void pushRelation(localUser, url, rating, comment) async {
    //Push to relational collection
    await this.relationalCollection.insert({
      'user_id': localUser,
      'recept_id': url,
      'my_rating': rating,
      'my_comments': comment
    });
  }

  // void pushRecipeClass(localUser, Recipe recipe) async {
  //   await pushRecipeArguments(
  //       localUser,
  //       recipe.getIngredients(),
  //       recipe.getInstructions(),
  //       recipe.getTitle(),
  //       recipe.getUrl(),
  //       recipe.getTime(),
  //       recipe.getRating());
  // }

  //Checks login, returns user session token
  login(username, password) async {
    try {
      var user = await this.userCollection.findOne({'username': username});
      if (user == null) {
        throw ArgumentError('User does not exist');
      }
      var hashedPwd = hashPassword(password, this.secretSalt);
      var userPwd = user['password'];
      if (hashedPwd == userPwd) {
        //print("Succesfull login");
        //Create session key, and add into userSession database
        var token = Uuid().v4();
        var session = {'username': username, 'sessionToken': token};
        await this.userSessions.save(session);
        return session;
      } else {
        throw ArgumentError('Password is not correct');
      }
    } catch (e) {
      return null;
    }
  }

  //logout, removes usersession
  logout(username, sessionToken) async {
    await this
        .userSessions
        .remove({'username': username, 'sessionToken': sessionToken});
  }

  //Register and pushes to database
  register(username, password) async {
    if (this.userCollection != null) {
      var query = await this.userCollection.findOne({'username': username});
      if (query == null) {
        //Add to user collection
        await this.userCollection.insert({
          'username': username,
          'password': hashPassword(password, this.secretSalt),
          'categories': []
        });
        print("Succesfully added user: " + username);
      } else {
        print("User exists already");
      }
    } else {
      print("Not connected to user Collection");
    }
  }

  //Check session to verify a legitimate user is requesting something from the database
  checkSession(username, sessionToken) async {
    var userSession = await this
        .userSessions
        .findOne({'username': username, 'sessionToken': sessionToken});
    if (userSessions != null) {
      return true;
    }
    print("Check session failed authentication");
    return false;
  }

  getCategories(username, sessionToken) async {
    if (await checkSession(username, sessionToken) || true) {
      var user = await this.userCollection.findOne({"username": username});
      return user['categories'];
    }
  }

  newCategory(username, sessionToken, category) async {
    if (await checkSession(username, sessionToken) || true) {
      var user = await this.userCollection.findOne({"username": username});
      List<dynamic> categories = user['categories'];
      if (!categories.contains(category)) {
        List<dynamic> newList = [];
        newList.add(category);
        newList.addAll(categories);
        user['categories'] = newList;
        print(user);
        await this.userCollection.update({'username': username}, user);
      } else {
        print("Category already exists");
      }
    }
  }

  addRecipeToCategory(username, sessionToken, category, Recipe recipe) async {
    if (checkSession(username, sessionToken) || true) {
      var relation = await this
          .relationalCollection
          .findOne({'user_id': username, 'recept_id': recipe.id});
      var categories = relation['categories'];
      List<dynamic> newList = [];
      newList.add(category);
      newList.addAll(categories);
      relation['categories'] = newList;
      await this
          .relationalCollection
          .update({'user_id': username, 'recept_id': recipe.id}, relation);
    }
  }

  //MÅSTE TESTS KÖRAS
  getRecipeFromCategory(userId, sessionToken, category) async {
    if (await checkSession(userId, sessionToken) || true) {
      List<Recipe> categories = [];
      await for (var streamedRecipe in this.relationalCollection.find({
        'user_id': userId,
        'categories': {'\$regex': '${category}'}
      })) {
        Recipe recipe = new Recipe(
            streamedRecipe['title'],
            streamedRecipe['ingredients'],
            streamedRecipe['instructions'],
            streamedRecipe['extra'],
            streamedRecipe['url'],
            streamedRecipe['portions'],
            streamedRecipe['picture']);
        categories.add(recipe);
      }
      print(categories.toString());
    }
  }

//Helpers
  String hashPassword(String pwd, String salt) {
    var key = utf8.encode(pwd);
    var bytes = utf8.encode(salt);

    var hmacSha256 = new Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }

  dynamic recipeInDB(url) async {
    var recipe = await this.recipeCollection.findOne({'_id': url});
    if (recipe == null) {
      return false;
    } else {
      return true;
    }
  }

  dynamic relationInDB(user, url) async {
    var relation = await this
        .relationalCollection
        .findOne({'user_id': user, 'recept_id': url});
    if (relation == null) {
      return false;
    } else {
      return true;
    }
  }

  void generateSalt() {
    var rand = Random();
    var bytes = List<int>.generate(32, (_) => rand.nextInt(256));
    print(base64.encode(bytes));
  }

  dynamic getCategories_old(username) async {
    //await collection.find(where.eq('name', 'Tom').gt('rating', 10)).toList();
    var profile = await this.userCollection.findOne({'username': username});
    if (profile['categories'] == null) {
      return [];
    }
    return profile['categories'];
  }

  closeDB() {
    db.close();
  }
}
