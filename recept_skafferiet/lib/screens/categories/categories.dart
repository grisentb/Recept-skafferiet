import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recept_skafferiet/DatabaseCommunication/apiComm.dart';
import 'package:recept_skafferiet/screens/categories/categoryCard.dart';
import 'package:recept_skafferiet/screens/recipe/recipe_screen.dart';

class Categories extends StatefulWidget {
  final session;
  Categories(this.session);
  State<StatefulWidget> createState() => _CategoriesPageState(session);
}

class _CategoriesPageState extends State<Categories> {
  var session;
  bool loaded = false;
  _CategoriesPageState(sess) {
    this.session = json.decode(sess); // kill me (-: :-)
  }
  List categories;
  @override
  void initState() {
    print('init categories...');
    super.initState();
    _getCategories();
  }

  _getCategories() async {
    var res = await ApiCommunication.getCategories(
        this.session['user_id'], this.session['sessionToken']);
    res = json.decode(res);
    if (res != null) {
      setState(() {
        this.categories = res;
        loaded = true;
      });
    } else {
      setState(() {
        this.categories = [];
        loaded = true;
      });
    }
  }

  Widget build(BuildContext context) {
    final title = 'Kategorier';
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
