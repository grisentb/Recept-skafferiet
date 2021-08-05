import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recept_skafferiet/DatabaseCommunication/apiComm.dart';
import 'package:recept_skafferiet/screens/home/home.dart';
import 'package:recept_skafferiet/screens/image_banner.dart';
import 'package:recept_skafferiet/screens/recipe/ingredients_list.dart';
import 'package:recept_skafferiet/screens/recipe/instructions_list.dart';
import 'dart:convert';


Widget recipeScreenNoRelation(var context, var session, String name, String url, String imgPath, List<String> ingredients, List<String> instructions, String extra, int portions){
  void addToMyRecipes() async {
    await ApiCommunication.pushRelation(
      session['user_id'], 
      session['sessionToken'], 
      url, 
      0, 
      "");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home(json.encode(session))));
  }
  void returnToHome() async {
    Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Home(json.encode(session))));
  }

  return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(name),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back
          ),
          onTap: returnToHome,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ImageBanner(imgPath, 200.0),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: IntrinsicHeight(
                  child: Row(children: [
                Expanded(
                  child: Text(
                    extra,
                    textAlign: TextAlign.right,
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey,
                  thickness: 2,
                  width: 20,
                ),
                Expanded(
                  child: Text(portions.toString() + " portioner"),
                ),
              ]))),
          Divider(color: Colors.black, thickness: 2),
          SizedBox(
              width: double.infinity,
              child: Container(
                child: Text("Ingredients:",
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              )),
          IngredientsList(ingredients),
          Divider(color: Colors.black, thickness: 2),
          SizedBox(
              width: double.infinity,
              child: Container(
                child: Text("Instructions:",
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              )),
          InstructionsList(instructions),
          ElevatedButton(
            onPressed: addToMyRecipes, 
            child: Text("Lägg till i min kokbok")
            ),
        ],
      ),
    );
}

