import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import "dart:math";
import 'package:crypto/crypto.dart';
import "package:recept_skafferiet/recipe.dart";

main(List<String> args) async {
  var recipe = new Recipe("FläskKotlett", ["Fläskkotlett", "sallad"],
      ["Lägg upp kotletterna", "Ät maten"], "ext", "PorkURL", 2, "img");
  var loginResponse = json.decode(await ApiCommunication.login("Tom", "123"));
  await ApiCommunication.pushRecipeClass(
      loginResponse['user_id'], loginResponse['sessionToken'], recipe);
  await ApiCommunication.pushRelation(loginResponse['user_id'],
      loginResponse['sessionToken'], recipe.url, 0, "");
  await ApiCommunication.logout(
      loginResponse['user_id'], loginResponse['sessionToken']);
}

class ApiCommunication {
  static const secretSalt = "VS/Sj3QMIHwUExeHXejcw717hrc49ckXlg+raLH2kA8=";
  static const apiAddress = "http://192.168.0.214:8080";
  //Authentication
  static login(username, password) async {
    var hashedPassword = hashPassword(password, secretSalt);
    var url = await Uri.parse(
        apiAddress + '/login/' + username + '/' + hashedPassword);
    var res = await http.get(url);
    return res.body;
  }

  static register(username, password) async {
    var hashedPassword = hashPassword(password, secretSalt);
    var url = await Uri.parse(
        apiAddress + '/register/' + username + '/' + hashedPassword);
    var res = await http.get(url);
    return res.body;
  }

  static logout(id, sessionToken) async {
    var url =
        await Uri.parse(apiAddress + '/logout/' + id + '/' + sessionToken);
    var res = await http.get(url);
    return res.body;
  }

  //Categories
  static getCategories(id, sessionToken) async {
    var url = await Uri.parse(
        apiAddress + '/getCategories/' + id + '/' + sessionToken);
    var res = await http.get(url);
    return res.body;
  }

  static newCategory(id, sessionToken, category) async {
    var url = await Uri.parse(apiAddress +
        '/newCategory/' +
        id +
        '/' +
        sessionToken +
        '/' +
        category);
    var res = await http.get(url);
    return res.body;
  }

  static addRecipeToCategory(id, sessionToken, category, Recipe recipe) async {
    var jsonRecipe = recipeToJsonString(recipe);
    var url = await Uri.parse(apiAddress +
        '/addRecipeToCategory/' +
        id +
        '/' +
        sessionToken +
        '/' +
        category +
        '/' +
        jsonRecipe);
    var res = await http.get(url);
    return res.body;
  }

  static getRecipesFromCategory(id, sessionToken, category) async {
    print(id);
    print(sessionToken);
    print(category);
    var url = await Uri.parse(apiAddress +
        '/getRecipesFromCategory/' +
        id +
        '/' +
        sessionToken +
        '/' +
        category);
    var res = await http.get(url);
    print(res.body);
  }

  //Recipe calls
  static getRecipes(userId, sessionToken) async {
    var url = await Uri.parse(
        apiAddress + '/getRecipes/' + userId + '/' + sessionToken);
    var res = await http.get(url);
    return res.body;
  }

  static getMyRecipes(userId, sessionToken) async {
    var url = await Uri.parse(
        apiAddress + '/getMyRecipes/' + userId + '/' + sessionToken);
    var res = await http.get(url);
    return res.body;
  }

  static pushRecipeClass(userId, sessionToken, Recipe recipe) async {
    var encodedRecipe = recipeToJsonString(recipe);
    var url = await Uri.parse(
        apiAddress + '/pushRecipe/' + userId + '/' + sessionToken);
    var res = await http.post(url, body: encodedRecipe);
    return res.body;
  }

  static pushRelation(userId, sessionToken, recipeId, rating, comment) async {
    var url = await Uri.parse(
        apiAddress + '/pushRelation/' + userId + '/' + sessionToken);
    var res = await http.post(url,
        body: json.encode(
            {"recipeId": recipeId, "rating": rating, "comment": comment}));
    return res.body;
  }

  static deleteRelation(userId, sessionToken, recipeId) async {
    var url = await Uri.parse(
        apiAddress + '/deleteRelation/' + userId + '/' + sessionToken);
    var res = await http.post(url, body: json.encode({"recipeId": recipeId}));
  }

  static updateRating(userId, sessionToken, recipeId, rating) async {
    var url = await Uri.parse(
        apiAddress + '/updateRating/' + userId + '/' + sessionToken);
    var res = await http.post(url,
        body: json.encode({"recipeId": recipeId, 'rating': rating}));
    return res.body;
  }

  static updateComment(userId, sessionToken, recipeId, comment) async {
    var url = await Uri.parse(
        apiAddress + '/updateComment/' + userId + '/' + sessionToken);
    var res = await http.post(url,
        body: json.encode({"recipeId": recipeId, 'comment': comment}));
    return res.body;
  }

  static deleteRecipe(userId, sessionToken, recipeId) async {
    var url = await Uri.parse(
        apiAddress + '/deleteRecipe/' + userId + '/' + sessionToken);
    var res = await http.post(url, body: json.encode({"recipeId": recipeId}));
    return res.body;
  }

  //Helpers
  static String hashPassword(String pwd, String salt) {
    var key = utf8.encode(pwd);
    var bytes = utf8.encode(salt);

    var hmacSha256 = new Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }

  static void generateSalt() {
    var rand = Random();
    var bytes = List<int>.generate(32, (_) => rand.nextInt(256));
    print(base64.encode(bytes));
  }

  static recipeToJsonString(Recipe recipe) {
    var jsonRecipe = {
      "title": recipe.title,
      "instructions": recipe.instructions,
      "ingridients": recipe.ingredients,
      "url": recipe.url,
      "extra": recipe.extra,
      "portions": recipe.portions,
      "image": recipe.image
    };
    return json.encode(jsonRecipe);
  }

  static recipeInDB(id, sessionToken) async {
    var url =
        await Uri.parse(apiAddress + '/recipeInDB/' + id + '/' + sessionToken);
    var res = await http.get(url);
    return res.body;
  }

  static relationInDB(userId, sessionToken, recipeId) async {
    var url = await Uri.parse(apiAddress +
        '/relationInDB/' +
        userId +
        '/' +
        sessionToken +
        '/' +
        recipeId);
    var res = await http.get(url);
    return res.body;
  }
}
