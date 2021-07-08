import 'Websites/coop.dart';
import 'Websites/koket.dart';
import 'Websites/ica.dart';
import 'package:recept_skafferiet/DatabaseCommunication/databaseComm.dart';

main(List<String> args) async {
  addScrape("https://www.ica.se/recept/pannkakor-grundsmet-20");
}

addScrape(domain) async {
  // Funktion som kollar om receptet redan finns i databasen
  // Om den inte finns så kalla på addNewScrape() och sedan på addRelation()
  final database = new DatabaseComm();
  await database.connectToCollections();
  var inDB = await database.getId(domain);

  if (!inDB) {
    await addNewScrape(domain, database);
  }

  await database.pushRelation("Hector", domain, null, null);

  database.closeDB();
}

addNewScrape(domain, database) async {
  var recipeObj;

  if (RegExp(r'\bhttps://www.coop.se\b').hasMatch(domain)) {
    recipeObj = await getScrapeCoop(domain);
  } else if (RegExp(r'\bhttps://www.ica.se\b').hasMatch(domain)) {
    recipeObj = await getScrapeIca(domain);
  } else if (RegExp(r'\bhttps://www.koket.se\b').hasMatch(domain)) {
    recipeObj = await getScrapeKoket(domain);
  } else {
    return;
  }
  await database.pushRecipeClass("test", recipeObj);
}
