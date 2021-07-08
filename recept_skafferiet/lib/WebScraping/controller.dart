import 'Websites/coop.dart';
import 'Websites/koket.dart';
import 'Websites/ica.dart';
import 'package:recept_skafferiet/DatabaseCommunication/databaseComm.dart';

main(List<String> args) async {
  var out = await addScrape(
      "https://www.coop.se/recept/ost-och-skinkpaj-grundrecept/");
  print(out);
}

addScrape(domain) async {
  // Funktion som kollar om receptet redan finns i databasen
  // Om den inte finns så kalla på addNewScrape() och sedan på addRelation()
  var outString = '';
  var isValidUrl = true;
  final database = new DatabaseComm();
  await database.connectToCollections();
  var recipeExist = await database.recipeInDB(domain);

  if (!recipeExist) {
    var isValid = await addNewScrape(domain, database);
    if (isValid == "domain") {
      outString = "Recept går inte att hämta från den här hemsidan";
      isValidUrl = false;
    } else if (isValid == "format") {
      outString = "Det går tyvärr inte att ladda ner det här receptet";
      isValidUrl = false;
    }
  }

  if (isValidUrl) {
    var relationExist = await database.relationInDB("User", domain);
    if (!relationExist) {
      await database.pushRelation("User", domain, null, null);
      outString = "Receptet är nu tillagt i din kokbok!";
    } else {
      outString = "Du har redan lagt till det här receptet till din kokbok";
    }
  }

  database.closeDB();
  return outString;
}

addNewScrape(domain, database) async {
  var recipeObj;
  try {
    if (RegExp(r'\bhttps://www.coop.se\b').hasMatch(domain)) {
      recipeObj = await getScrapeCoop(domain);
    } else if (RegExp(r'\bhttps://www.ica.se\b').hasMatch(domain)) {
      recipeObj = await getScrapeIca(domain);
    } else if (RegExp(r'\bhttps://www.koket.se\b').hasMatch(domain)) {
      recipeObj = await getScrapeKoket(domain);
    } else {
      return "domain";
    }
    await database.pushRecipeClass("user", recipeObj);
  } catch (e) {
    return "format";
  }
}
