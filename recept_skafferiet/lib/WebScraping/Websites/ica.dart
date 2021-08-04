import 'package:web_scraper/web_scraper.dart';
import 'package:recept_skafferiet/recipe.dart';

Future<Recipe> getScrapeIca(domain) async {
  final webScraper = WebScraper('https://www.ica.se');
  var domain_tail = domain.replaceAll("https://www.ica.se", "");
  try {
    if (await webScraper.loadWebPage(domain_tail)) {
      // Scrapes the list of ingredients
      List<Map<String, dynamic>> ingredients = webScraper.getElement(
          'div.row-noGutter-column'
          '> div'
          '> div.ingredients-list-group__card',
          ['title']);
      // Scrapes the list of instructuins
      List<Map<String, dynamic>> instructions =
          webScraper.getElement('div.cooking-steps-main__text', ['title']);
      // Scrapes tRegExp(r'\bhttps://coop.se\b').hasMatch(domain)he title of the recipe
      List<Map<String, dynamic>> recipeTitle = webScraper.getElement(
          // 'div.recipe-headerwrapper col_sm-12_md-6_xl-5'
          'div.recipe-header__wrapper-inner'
          '> h1',
          ['title']);
      // Scrapes the time it takes to complete the recipe
      List<Map<String, dynamic>> recipeTime = webScraper.getElement(
          'div.recipe-header__summary'
          '> a.items:first-child',
          ['title']);

      List<Map<String, dynamic>> recipePortions = webScraper.getElement(
          'div.ingredients-change-portions'
          '>div',
          ['title']);

      List<Map<String, dynamic>> imgSrc = webScraper.getElement(
          'div.recipe-header__desktop-image-wrapper__inner'
          '> img',
          ['src']);

      final List<String> ingredientList = [];
      final List<String> instructionList = [];
      final title = recipeTitle[0]['title'];
      var time = recipeTime[0]['title'];
      var portions = recipePortions[0]['title'];
      var img = imgSrc[0]['attributes']['src'];

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

      time = time
          .replaceAll(RegExp(r"\s+"), " ")
          .replaceAll(RegExp(r"^\s"), "")
          .replaceAll(RegExp(r"\s$"), "");

      portions = portions.replaceAll(RegExp(r"\D"), "");

      //Returns a recipe object with given elements
      return new Recipe(
          title, ingredientList, instructionList, time, domain, portions, img);
    }
  } catch (e) {
    throw FormatException("Wrong format");
  }
}
