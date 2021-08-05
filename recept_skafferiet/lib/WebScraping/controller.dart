import 'package:recept_skafferiet/recipe.dart';

import 'Websites/coop.dart';
import 'Websites/koket.dart';
import 'Websites/ica.dart';
import 'package:recept_skafferiet/DatabaseCommunication/databaseComm.dart';
import 'package:recept_skafferiet/DatabaseCommunication/apiComm.dart';

main(List<String> args) async {}

scrapeRecipeObj(url) async {
  Recipe recipeObj;
  if (RegExp(r'\bhttps://www.coop.se\b').hasMatch(url)) {
    recipeObj = await getScrapeCoop(url);
    recipeObj.portions = int.parse(recipeObj.portions);
  } else if (RegExp(r'\bhttps://www.ica.se\b').hasMatch(url)) {
    recipeObj = await getScrapeIca(url);
    recipeObj.portions = int.parse(recipeObj.portions);
  } else if (RegExp(r'\bhttps://www.koket.se\b').hasMatch(url)) {
    recipeObj = await getScrapeKoket(url);
    recipeObj.portions = int.parse(recipeObj.portions);
  } else {
    throw NotAllowedUrl();
    return;
  }
  return recipeObj;
}

addScrapeNew(uid, session, url) async {
  var outString = '';
  var isValidUrl = true;

  try {
    var recipe = await scrapeRecipeObj(url);
    await ApiCommunication.pushRecipeClass(uid, session, recipe);
    var res =
        await ApiCommunication.pushRelation(uid, session, url, 0, "");
    if (res == "Relation already in database") {
      throw AlreadyAdded();
    } else {
      return "Receptet är nu tillagt i din kokbok!";
    }
  } on FormatException catch (e) {
    return "Det går tyvärr inte att ladda ner det här receptet";
  } on NotAllowedUrl catch (e) {
    return "Vi kan tyvärr inte ladda ner recept från den här hemsidan";
  } on AlreadyAdded catch (e) {
    return "Du har redan lagt till det här receptet i din kokbok";
  }
}

class NotAllowedUrl implements Exception {
  String errMsg() => 'This url cannot be scraped';
}

class AlreadyAdded implements Exception {
  String errMsg() => 'This relation already exists in the database';
}
