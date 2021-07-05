import 'package:web_scraper/web_scraper.dart';
import 'package:recept_skafferiet/recipe.dart';

Future<Recipe> getScrapeKoket(domain) async {
  final webScraper = WebScraper('https://www.koket.se');
  var domain_tail = domain.replaceAll("https://www.koket.se", "");
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
    List<Map<String, dynamic>> recipeName = webScraper
        .getElement('h1.recipe_title__3Uhx6.recipe_mobile__2VTII', ['title']);
    // Scrapes the time it takes to complete the recipe
    List<Map<String, dynamic>> time = webScraper.getElement(
        'div.details_wrapper__3Euwd'
        '> p:last-child',
        ['title']);

    final List<String> ingredientList = [];
    final List<String> instructionList = [];
    final recipeTitle = recipeName[0]['title'];
    final recipeTime = time[0]['title'];

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

    //Returns a recipe object with given elements
    return new Recipe(
        recipeTitle, ingredientList, instructionList, recipeTime, domain);
  }
}
