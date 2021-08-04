import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import "package:uuid/uuid.dart";
import 'dart:convert';

final Db db = Db("mongodb://localhost:27017/ReceptSkafferiet");
DbCollection recipeCollection = db.collection("Recipes");
DbCollection userCollection = db.collection("Users");
DbCollection relationalCollection = db.collection("Relational");
DbCollection userSessions = db.collection("UserSessions");

//Open database
connectToDatabase() {
  db.open();
}

//Check session
Future<bool> checkSession(id, sessionToken) async {
  var Objectid = ObjectId.parse(id);
  print(sessionToken);
  var session = await userSessions
      .findOne({"user_id": Objectid, "sessionToken": sessionToken});
  if (session != null) {
    return true; //True == session does exists
  }
  return false;
}

//Register, login & logout
Future<Response> loginHandler(Request request, username, password) async {
  try {
    var user = await userCollection.findOne({"username": username});
    if (user == null) {
      throw ArgumentError("User doesn't exist.");
    } else {
      if (password == user['password']) {
        var token = Uuid().v4();
        var session = {'user_id': user['_id'], 'sessionToken': token};
        await userSessions.insertOne(session);
        return Response(200,
            body: json.encode(session),
            headers: {'Access-Control-Allow-Origin': '*'});
      } else {
        throw ArgumentError("Password is not correct");
      }
    }
  } catch (e) {
    return Response(200, body: null);
  }
}

Future<Response> registerHandler(Request request, username, password) async {
  var query = await userCollection.findOne({'username': username});
  if (query == null) {
    await userCollection.insertOne(
        {'username': username, 'password': password, 'categories': []});
    return Response.ok("Successfully added user: " + username);
  } else {
    return Response.ok("User already exists");
  }
}

Future<Response> logoutHandler(Request request, id, sessionToken) async {
  await checkSession(id, sessionToken);
  await userSessions
      .remove({'user_id': ObjectId.parse(id), "sessionToken": sessionToken});
  return Response.ok("Succesfully logged out");
}

//Category related querys
Future<Response> getCategoriesHandler(Request request, id, sessionToken) async {
  var session = await checkSession(id, sessionToken);
  if (session) {
    var user = await userCollection.findOne({"_id": ObjectId.parse(id)});
    return Response.ok(json.encode(user!['categories']));
  }
  return Response.ok("Session is not active");
}

Future<Response> newCategoryHandler(
    Request request, id, sessionToken, category) async {
  var session = await checkSession(id, sessionToken);
  if (session) {
    var user = await userCollection.findOne({"_id": ObjectId.parse(id)});
    List<dynamic> categories = user!['categories'];
    if (!categories.contains(category)) {
      List<dynamic> newList = [];
      newList.add(category);
      newList.addAll(categories);
      user['categories'] = newList;
      await userCollection.update({"_id": ObjectId.parse(id)}, user);
      return Response.ok(category + " added to categories");
    } else {
      return Response.ok(category + " does already exist");
    }
  } else {
    return Response.ok("Session not valid");
  }
}

Future<Response> addRecipeToCategoryHandler(
    Request request, id, sessionToken, category, recipe) async {
  var session = await checkSession(id, sessionToken);
  if (session) {
    var relation = await relationalCollection
        .findOne({"user_id": ObjectId.parse(id), "recipe_id": recipe['id']});
    var categories = relation!['categories'];
    List<dynamic> newList = [];
    newList.add(category);
    newList.addAll(categories);
    relation['categories'] = newList;
    await relationalCollection.update(
        {'user_id': ObjectId.parse(id), 'recipe_id': recipe['id']}, relation);
    return Response.ok("Recipe added");
  } else {
    return Response.ok("Session not valid");
  }
}

Future<Response> getRecipeFromCategoryHandler(
    Request request, id, sessionToken, category) async {
  var session = await checkSession(id, sessionToken);
  if (session) {
    List<dynamic> recipes = [];
    await for (var streamedRecipe in relationalCollection.find({
      'user_id': ObjectId.parse(id),
      'categories': {'\$regex': '${category}'}
    })) {
      recipes.add(json.encode(streamedRecipe));
    }

    return Response.ok(recipes);
  } else {
    return Response.ok("Session not valid");
  }
}

Future<Response> getRecipesHandler(
    Request request, userId, sessionToken) async {
  var session = await checkSession(userId, sessionToken);
  if (session) {
    var recipes = [];
    await for (var streamedRecipe
        in recipeCollection.find({'user_id': userId})) {
      recipes.add(json.encode(streamedRecipe));
    }
    return Response.ok(recipes);
  } else {
    throw ArgumentError("Session is not valid");
  }
}

Future<Response> pushRecipeHandler(
    Request request, userId, sessionToken) async {
  var session = await checkSession(userId, sessionToken);
  if (session) {
    var codec = Utf8Codec();
    String body = "";
    await for (var streamedElement in request.read()) {
      body += codec.decode(streamedElement);
    }
    var recipe = json.decode(body);

    if (!await recipeInDB(recipe['url'])) {
      await recipeCollection.insertOne({
        'title': recipe['title'],
        'instructions': recipe['instructions'],
        'ingredients': recipe['ingredients'],
        'url': recipe['url'],
        'extra': recipe['extra'],
        'portions': recipe['portions'],
        'image': recipe['image'],
      });
      return Response(200, body: "Added recipe to Collection");
    } else {
      return Response(199, body: "Already in databse");
    }
  } else {
    throw ArgumentError("Session is not valid");
  }
}

Future<Response> pushRelationHandler(
    Request request, userId, sessionToken) async {
  var session = await checkSession(userId, sessionToken);
  if (session) {
    var codec = Utf8Codec();
    String body = "";
    await for (var streamedElement in request.read()) {
      body += codec.decode(streamedElement);
    }
    var relation = json.decode(body);
    var recipeId = relation['recipeId'];
    var rating = relation['rating'];
    var comment = relation['comment'];
    if (!await relationInDB(userId, recipeId)) {
      await relationalCollection.insert({
        'user_id': userId,
        'recipe_id': recipeId,
        'rating': rating,
        'comment': comment
      });
      return Response(200, body: "Relation is pushed to database");
    } else {
      return Response(200, body: "Relation already in database");
    }
  } else {
    throw ArgumentError("Session is not valid");
  }
}

Future<Response> updateRatingHandler(
    Request request, userId, sessionToken, recipeId, rating) async {
  var session = await checkSession(userId, sessionToken);
  if (session) {
    var codec = Utf8Codec();
    String body = "";
    await for (var streamedElement in request.read()) {
      body += codec.decode(streamedElement);
    }
    var rating = json.decode(body)['rating'];

    var relation = await relationalCollection
        .findOne({'user_id': userId, 'recipe_id': recipeId});

    relation!['rating'] = rating;

    relationalCollection
        .update({'user_id': userId, 'recipe_id': recipeId}, relation);
    return Response(200, body: "Updated rating");
  } else {
    throw ArgumentError("Session is not valid");
  }
}

Future<Response> updateCommentHandler(
    Request request, userId, sessionToken, recipeId) async {
  var session = await checkSession(userId, sessionToken);
  if (session) {
    var codec = Utf8Codec();
    String body = "";
    await for (var streamedElement in request.read()) {
      body += codec.decode(streamedElement);
    }
    var comment = json.decode(body)['comment'];

    var relation = await relationalCollection
        .findOne({'user_id': userId, 'recipe_id': recipeId});

    relation!['comment'] = comment;

    relationalCollection
        .update({'user_id': userId, 'recipe_id': recipeId}, relation);
    return Response(200, body: "Updated comment");
  } else {
    throw ArgumentError("Session is not valid");
  }
}

//Helpers

Future<bool> recipeInDB(recipeId) async {
  var recipe = await recipeCollection.findOne({'url': recipeId});
  if (recipe == null) {
    return false;
  } else {
    return true;
  }
}

Future<bool> relationInDB(userId, recipeId) async {
  var relation = await relationalCollection
      .findOne({'user_id': userId, 'recipe_id': recipeId});
  if (relation == null) {
    return false;
  } else {
    return true;
  }
}
