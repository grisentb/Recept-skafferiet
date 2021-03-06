//Dart mongo pakcage: https://pub.dev/packages/mongo_dart
import 'dart:convert';
import "dart:math";
import 'package:crypto/crypto.dart';
import "package:mongo_dart/mongo_dart.dart";
import "package:recept_skafferiet_app/recipe.dart";
import "package:uuid/uuid.dart";

main() async{
  print("Starting");
  var dbComm = new DatabaseComm();
  await dbComm.connectToCollections();
  print('Connected');
}

class DatabaseComm {
  final db = Db("mongodb://localhost:27017/ReceptSkafferiet");
  final secretSalt = "VS/Sj3QMIHwUExeHXejcw717hrc49ckXlg+raLH2kA8=";
  
  var recipeCollection;
  var userCollection;
  var relationalCollection;
  var userSessions;

  connectToCollections() async{
    await db.open();
    this.recipeCollection = await db.collection('Recipes');
    this.userCollection = await db.collection('Users');
    this.relationalCollection = await db.collection('Relatinoal');
    this.userSessions = await db.collection('userSessions');
    print("Connected to the Collections succesfully");
  }
  
  //Gets all recipes connected to a specific user. Takes the specific users id as argument and returns a list of all recipes 
  Future<List<Recipe>> getRecipeIds(localUser) async {
    var relations = await this.recipeCollection.find({'user_id': localUser}).toList();
    List<Recipe> recipes = [];
    for (var relation in relations){
      print(relation);
      var recipe = await this.recipeCollection.findOne({
        '_id': relation['recept_id']
      });

      recipes.add(new Recipe(
        recipe['ingredients'],
        recipe['instructions'],
        recipe['title'],
        recipe['description']
      ));
    }
    return recipes;
  }
  
  //Push recipe
  void pushRecipeArguments(localUser, ingredients, instructions, title, description, url, time, peopleRating) async {
    //Check if the recipe already exists, if it does not, push to recipe collection
    var recipeId = getId(url);
    if (recipeId == null){
      this.recipeCollection.insert(
        {
          '_id': localUser,
          'url': url,
          'title': title,
          'description': description,
          'ingridients': ingredients,
          'instructions': instructions,
          'time': time,
          'rating': peopleRating
        }
      );
    }
    //Push to relational collection
    this.relationalCollection.insert(
      {
        'user_id': localUser,
        'recept_id': recipeId,
        'my_rating': "",
        'my_comments': ""
      }
    );
  }

  void pushRecipeClass(localUser, Recipe recipe) async {
    await pushRecipeArguments(localUser,
    recipe.getIngridients(), 
    recipe.getInstructions(), 
    recipe.getTitle(), 
    recipe.getDescription(),
    recipe.getUrl(),
    recipe.getTime(),
    recipe.getRating());
  }
  //Checks login, returns user session token
  login(username, password) async {
    try {
    var user = await this.userCollection.findOne(
      {
        'username': username
      }
    );
    if(user == null){throw ArgumentError('User does not exist');}
    var hashedPwd = hashPassword(password, this.secretSalt);
    var userPwd = user['password'];
    if(hashedPwd == userPwd){
      //print("Succesfull login");
      //Create session key, and add into userSession database
      var token = Uuid().v4();
      var session = {'username': username, 'sessionToken': token};
      await this.userSessions.save(session);
      return token;
    } else {throw ArgumentError('Password is not correct');}
    } catch (e) {
      //print('Failed login');
    }
  }

  //logout, removes usersession
  logout(username, sessionToken) async{
    await this.userSessions.deleteOne({'username': username, 'sessionToken': sessionToken});
  }
  //Register and pushes to 
  void register(username, password) async{
    if(this.userCollection != null){
      var query = await this.userCollection.findOne({'username': username});
      if (query == null){
        //Add to user collection
        await this.userCollection.insert(
          {
            'username': username,
            'password': hashPassword(password, this.secretSalt)
          }
        );
        print("Succesfully added user: " + username);
      }else{
        print("User exists already");
      }
    }else {
      print("Not connected to user Collection");
    }
  }

  //Check session
  checkSession(username, sessionToken) async {
    var userSession = await this.userSessions.findOne({'username':username, 'sessionToken': sessionToken});
    if(userSessions != null){return true;}
    return false;
  }
//Helpers
  String hashPassword(String pwd, String salt){
    var key = utf8.encode(pwd);
    var bytes = utf8.encode(salt);

    var hmacSha256 = new Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }
  
  dynamic getId(url) async {
    var recipe = await this.recipeCollection.findOne({'url': url});
    return recipe['id'];
  }
  
  void generateSalt(){
    var rand = Random();
    var bytes = List<int>.generate(32, (_) => rand.nextInt(256));
    print(base64.encode(bytes));
  }
}