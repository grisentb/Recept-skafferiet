import 'package:http/http.dart' as http;
import 'dart:convert';
import "dart:math";
import 'package:crypto/crypto.dart';
import "package:recept_skafferiet/recipe.dart";

main(List<String> args) async {
  var loginResponse = json.decode(await ApiCommunication.login("Tom", "123"));
  //print(loginResponse);
  var res = await ApiCommunication.getCategories(loginResponse["user_id"].toString(), loginResponse["sessionToken"].toString());
  print(res);
}


class ApiCommunication {
  static const secretSalt = "VS/Sj3QMIHwUExeHXejcw717hrc49ckXlg+raLH2kA8=";

  static login(username, password)async {
    var hashedPassword = hashPassword(password, secretSalt);
    var url = await Uri.parse('http://localhost:8080/login/' + username + '/' + hashedPassword);
    var res = await http.get(url);
    return res.body;
  }

  static register(username, password) async {
    var hashedPassword = hashPassword(password, secretSalt);
    var url = await Uri.parse('http://localhost:8080/register/' + username + '/' + hashedPassword);
    var res = await http.get(url);
    return res.body;
  }

  static logout(id, sessionToken) async {
    var url = await Uri.parse('http://localhost:8080/logout/' + id + '/' + sessionToken);
    var res = await http.get(url);
    return res.body;
  }

  static getCategories(id, sessionToken) async {
    var url = await Uri.parse('http://localhost:8080/getCategories/' + id + '/' + sessionToken);
    var res = await http.get(url);
    return res.body;
  }
  
  static newCategory(id, sessionToken, category) async {
    var url = await Uri.parse('http://localhost:8080/newCategory/' + id + '/' + sessionToken + '/' + category);
    var res = await http.get(url);
    return res.body;
  }
  
  static addRecipeToCategory(id, sessionToken, category, Recipe recipe) async {
    var jsonRecipe = {
      'title': recipe.title,
      'ingridents' : recipe.ingredients,
      'instructions' : recipe.instructions,
      'extra' : recipe.extra,
      'url' : recipe.url,
      'portions' : recipe.portions,
      'picture' : recipe.image,
    };
    var url = await Uri.parse('http://localhost:8080/addRecipeToCategory/' + id + '/' + sessionToken  + '/' + category + '/' + jsonRecipe.toString());
    var res = await http.get(url);
    return res.body;
  }

  static getRecipeFromCategory(id, sessionToken, category) async {
    print(id);
    print(sessionToken);
    print(category);
    var url = await Uri.parse('http://localhost:8080/getRecipeFromCategory/' + id + '/' + sessionToken + '/' + category);
    var res = await http.get(url);
    print(res.body);
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
}