import 'package:web_scraper/web_scraper.dart';
import 'package:recept_skafferiet/recipe.dart';

Future<Recipe> getScrapeCoop(domain) async {
  final webScraper = WebScraper('https://www.coop.se');
  var domain_tail = domain.replaceAll("https://www.coop.se", "");
  if (await webScraper.loadWebPage(domain_tail)) {
    // Scrapes the list of ingredients
    List<Map<String, dynamic>> ingredients = webScraper.getElement(
        'div.SidebarNav-content'
        '> div.IngredientList'
        '> div.IngredientList-container'
        '> div.IngredientList-content'
        '> ul.List.List--section'
        '> li.u-paddingHxsm.u-textNormal.u-colorBase',
        ['title']);
    // Scrapes the list of instructuins
    List<Map<String, dynamic>> instructions = webScraper.getElement(
        'div.Grid-cell'
        '> div.u-paddingVxlg.u-paddingHlg.u-lg-paddingHxlg.u-paddingTlg.u-bgWhite'
        '> div'
        '> ol.List.List--orderedRecipe.u-textNormal'
        '> li.u-colorBase',
        ['title']);
    // Scrapes tRegExp(r'\bhttps://coop.se\b').hasMatch(domain)he title of the recipe
    List<Map<String, dynamic>> recipeName = webScraper.getElement(
        'div.Grid-cell'
        '> div.u-paddingVxlg.u-paddingTlg.u-sm-paddingTxlg.u-paddingHlg.u-lg-paddingHxlg.u-lg-paddingBz.u-bgWhite'
        '> h1.u-textFamilySecondary.u-marginBxsm',
        ['title']);
    // Scrapes the time it takes to complete the recipe
    List<Map<String, dynamic>> time = webScraper.getElement(
        'div.Grid-cell'
        '> div.u-paddingVxlg.u-paddingTlg.u-sm-paddingTxlg.u-paddingHlg.u-lg-paddingHxlg.u-lg-paddingBz.u-bgWhite'
        '> div.u-marginTlg'
        '> div.Grid.Grid--gutterHxlg.Grid--gutterVxsm.Grid--fit'
        '> div.Grid-cell.Grid-cell--fit.u-borderRight2'
        '> span',
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
