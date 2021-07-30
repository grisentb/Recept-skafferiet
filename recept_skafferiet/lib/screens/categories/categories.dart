import 'package:flutter/material.dart';
import 'package:recept_skafferiet/DatabaseCommunication/databaseComm.dart';
import 'package:recept_skafferiet/screens/categories/categoryCard.dart';
import 'package:recept_skafferiet/screens/recipe/recipe_screen.dart';

// ignore: must_be_immutable
class Categories extends StatefulWidget {
  var session;
  State<StatefulWidget> createState() => _CategoriesPageState(session);
  Categories(this.session);
}

class _CategoriesPageState extends State<Categories> {
  var session;
  bool loaded = false;
  _CategoriesPageState(this.session);
  final dbComm = new DatabaseComm();
  List categories;
  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  _getCategories() async {
    await this.dbComm.connectToCollections();
    List cats = await this.dbComm.getCategories(session['username']);
    setState(() {
      this.categories = cats;
      loaded = true;
    });
  }

  Widget build(BuildContext context) {
    final title = 'Kategorier, session: ' + this.session['sessionToken'];
    return MaterialApp(
      title: title,
      onGenerateRoute: (settings) {
        if (settings.name == RecipeScreen.route) {
          final args = settings.arguments as RecipeScreenArguments;

          return MaterialPageRoute(builder: (context) {
            return RecipeScreen(
                name: args.name,
                imgPath: args.imgPath,
                score: args.score,
                ingredients: args
                    .ingredients, //Later these should be loaded in when rendered
                instructions: args
                    .instructions, //Later these should be loaded in when rendered
                extra: args.extra,
                portions: args.portions);
          });
        } else {
          return null;
        }
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
            child: (loaded)
                ? ((this.categories.isNotEmpty)
                    ? ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return Center(child: CategoryCard(categories[index]));
                        })
                    : Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.03,
                            0.0,
                            MediaQuery.of(context).size.width * 0.03,
                            0.0),
                        child: Text(
                            'Inga kategorier tillagda. Lägg till genom att antingen lägga till ett nytt recept eller markera ett redan existerande recept med en kategori.')))
                : CircularProgressIndicator()),
      ),
    );
  }
}