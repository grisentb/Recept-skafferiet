import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import "package:uuid/uuid.dart";
import 'dart:convert';

final Db db = Db("mongodb://localhost:27017/ReceptSkafferietDB");
DbCollection recipeCollection = db.collection("Recipes");
DbCollection userCollection = db.collection("Users");
DbCollection relationalCollection = db.collection("Relational");
DbCollection userSessions = db.collection("UserSessions");


//Open database
connectToDatabase(){
  db.open();
}
//Check session
Future<bool> checkSession(id, sessionToken) async {
  var Objectid = ObjectId.parse(id);
  var session = await userSessions.findOne({"user_id": Objectid, "sessionToken":sessionToken});
  if(session != null){
    return true; //True == session does exists
  }
  return false;
  }

//Register, login & logout
Future<Response> loginHandler(Request request, username, password) async {
  try {
    var user = await userCollection.findOne({"username" : username});
    if(user == null){
      throw ArgumentError("User doesn't exist.");
    }else {
      if(password == user['password']){
        var token = Uuid().v4();
        var session = {'user_id' : user['_id'], 'sessionToken': token};
        await userSessions.insertOne(session);
        return Response.ok(json.encode(session));
      }else {
        throw ArgumentError("Password is not correct");
      }
    }
  } catch (e) {
    return Response.ok("");
  }
}

Future<Response> registerHandler(Request request, username, password) async {
  var query = await userCollection.findOne({'username' : username});
  if(query == null){
    await userCollection.insertOne({
      'username':username, 
      'password':password,
      'categories':[]
      });
    return Response.ok("Successfully added user: " + username);
  }
  else{
    return Response.ok("User already exists");
  }
}

Future<Response> logoutHandler(Request request, id, sessionToken)async {
  await checkSession(id, sessionToken);
  await userSessions.remove({'user_id': ObjectId.parse(id), "sessionToken": sessionToken});
  return Response.ok("Succesfully loggedout");
}

//Category related querys
Future<Response> getCategoriesHandler(Request request, id, sessionToken) async {
  var session = await checkSession(id, sessionToken);
  if(session){
    var user = await userCollection.findOne({"_id": ObjectId.parse(id)});
    return Response.ok(json.encode(user!['categories']));
  }
  return Response.ok("Session is not active");
}

Future<Response> newCategoryHandler(Request request, id, sessionToken, category) async {
  var session = await checkSession(id, sessionToken);
  if(session){
    var user = await userCollection.findOne({"_id": ObjectId.parse(id)});
    List<dynamic> categories = user!['categories'];
    if(!categories.contains(category)){
      List<dynamic> newList = [];
      newList.add(category);
      newList.addAll(categories);
      user['categories'] = newList;
      await userCollection.update({"_id": ObjectId.parse(id)}, user);
      return Response.ok(category + " added to categories");
    }else {
      return Response.ok(category + " does already exist");
    }
  }else {
    return Response.ok("Session not valid");
  }
}

Future<Response> addRecipeToCategoryHandler(Request request, id, sessionToken, category, recipe) async {
  var session = await checkSession(id, sessionToken);
  if(session) {
      var relation = await relationalCollection.findOne({"user_id": ObjectId.parse(id), "recipe_id": recipe['id']});
      var categories = relation!['categories'];
      List<dynamic> newList = [];
      newList.add(category);
      newList.addAll(categories);
      relation['categories'] = newList;
      await relationalCollection.update({'user_id': ObjectId.parse(id), 'recipe_id': recipe['id']}, relation);
      return Response.ok("Recipe added");
  }else{
    return Response.ok("Session not valid");
  }
}

Future<Response> getRecipeFromCategoryHandler(Request request, id, sessionToken, category) async {
  var session = await checkSession(id, sessionToken);
  if(session) {
    List<dynamic> categories = [];
    await for (var streamedRecipe in relationalCollection.find({'user_id' : ObjectId.parse(id), 'categories':{'\$regex': '${category}'}})){
      categories.add(streamedRecipe);
    }

    return Response.ok('$categories');
  }else{
    return Response.ok("Session not valid");
  }
}





