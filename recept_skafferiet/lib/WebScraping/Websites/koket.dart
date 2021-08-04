import 'package:web_scraper/web_scraper.dart';
import 'package:recept_skafferiet/recipe.dart';

Future<Recipe> getScrapeKoket(domain) async {
  final webScraper = WebScraper('https://www.koket.se');
  var domain_tail = domain.replaceAll("https://www.koket.se", "");
  try {
    if (await webScraper.loadWebPage(domain_tail)) {
      // Scrapes the list of ingredients
      List<Map<String, dynamic>> ingredients =
          webScraper.getElement('span.ingredient', ['title']);
      // Scrapes the list of instructuins
      List<Map<String, dynamic>> instructions = webScraper.getElement(
          'ol.step-by-step_numberedList__1Qy46'
          '> li'
          '> span',
          ['title']);
      // Scrapes tRegExp(r'\bhttps://coop.se\b').hasMatch(domain)he title of the recipe
      List<Map<String, dynamic>> recipeTitle = webScraper
          .getElement('h1.recipe_title__3Uhx6.recipe_mobile__2VTII', ['title']);
      // Scrapes the time it takes to complete the recipe
      List<Map<String, dynamic>> recipeTime = webScraper.getElement(
          'div.details_wrapper__3Euwd'
          '> p:last-child',
          ['title']);
      List<Map<String, dynamic>> recipePortions =
          webScraper.getElement('span.portions_portions__3s3hs', ['title']);
      List<Map<String, dynamic>> recipeImage =
          webScraper.getElement('img.media_recipeImage__3l3Nm', ['src']);

      final List<String> ingredientList = [];
      final List<String> instructionList = [];
      final title = recipeTitle[0]['title'];
      final time = recipeTime[0]['title'];
      final portions = recipePortions[0]['title'];
      var img = null;
      if (recipeImage.length != 0) {
        img = recipeImage[0]['attributes']['src'];
      }
      // Use of regex to format the text
      ingredients.forEach((element) {
        final title = element['title']
            .replaceAll(RegExp(r"\s+"), " ")
            .replaceAll(RegExp(r"^\s"), "")
            .replaceAll(RegExp(r"\s$"), "");
        ingredientList.add('$title');
      });

      instructions.forEach((element) {
        final title = element['title']
            .replaceAll(RegExp(r"\s+"), " ")
            .replaceAll(RegExp(r"^\s"), "")
            .replaceAll(RegExp(r"\s$"), "");
        instructionList.add('$title');
      });

      print(portions);
      print(img);
      //Returns a recipe object with given elements
      return new Recipe(
          title, ingredientList, instructionList, time, domain, portions, img);
    }
  } catch (e) {
    throw FormatException("Wrong format");
  }
}
