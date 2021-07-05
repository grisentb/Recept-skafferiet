import 'Websites/coop.dart';
import 'Websites/koket.dart';
import 'package:recept_skafferiet/DatabaseCommunication/databaseComm.dart';

main(List<String> args) async {
  addScrape(
      "https://www.koket.se/leila-bakar-i-frankrike/leila-lindholm/korsbarsclafouti/");
}

addScrape(domain) {
  // Funktion som kollar om receptet redan finns i databasen
  // Om den inte finns så kalla på addNewScrape() och sedan på addRelation()
  addNewScrape(domain);
  // Om den redan finns kalla endast på addRelation()
}

addNewScrape(domain) async {
  var recipeObj = null;

  if (RegExp(r'\bhttps://www.coop.se\b').hasMatch(domain)) {
    recipeObj = await getScrapeCoop(domain);
  } else if (RegExp(r'\bhttps://www.ica.se\b').hasMatch(domain)) {
    print("ica");
  } else if (RegExp(r'\bhttps://www.koket.se\b').hasMatch(domain)) {
    recipeObj = await getScrapeKoket(domain);
  } else {
    return;
  }

  final database = new DatabaseComm();
  await database.connectToCollections();
  print(recipeObj.time);
  await database.pushRecipeClass("test", recipeObj);
  database.closeDB();
}
