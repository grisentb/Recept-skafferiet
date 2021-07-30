import 'dart:core';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'recipe.dart';

main(List<String> args) {
  List<Recipe> recipes = [new Recipe("Asparagus", "Test", "Test", "Test", "Test", "Test", "Test"),
  new Recipe("Tranberry Vodka", "Test", "Test", "Test", "Test", "Test", "Test"),
  new Recipe("Linguini", "Test", "Test", "Test", "Test", "Test", "Test"),
  new Recipe("Beef", "Test", "Test", "Test", "Test", "Test", "Test"),
  new Recipe("Anus", "Test", "Test", "Test", "Test", "Test", "Test"),
  new Recipe("IsGlass", "Test", "Test", "Test", "Test", "Test", "Test"),
  new Recipe("MangoChutney", "Test", "Test", "Test", "Test", "Test", "Test"),
  new Recipe("Rocky", "Test", "Test", "Test", "Test", "Test", "Test"),
  new Recipe("Köttbullar", "Test", "Test", "Test", "Test", "Test", "Test"),
  new Recipe("Potatismos", "Test", "Test", "Test", "Test", "Test", "Test")];
  var sorting = new SortingRecipes();
  sorting.sortRecipesByTitle(recipes, 0, recipes.length-1).forEach((element) {print(element.title);});
}

class SortingRecipes{
  List<Recipe> list;
   
  List<Recipe> sortRecipesByTitle(List<Recipe> recipes, int lower, int upper){
    this.list = recipes;
    this._sortRecipesByTitle(lower, upper);
    return this.list;
  }

  _sortRecipesByTitle(int lower, int upper){

    if (upper - lower > 1 && upper > lower){
      int pivotIndex = ((upper-lower)/2 + lower).ceil();
      pivotIndex = this.sortPivotByTitle(pivotIndex, lower, upper);
      
     this._sortRecipesByTitle(lower, pivotIndex-1);
     
     this._sortRecipesByTitle(pivotIndex+1, upper);

    }else{
      if(this.list[upper].title.compareTo(this.list[lower].title) < 0 && upper > lower){
        var temp = this.list[upper];
        print("temp " + temp.toString());
        this.list[upper] = this.list[lower];
        this.list[lower] = temp;
      }
      return;
    }
  }
  
  sortPivotByTitle(int pivotIndex, int lower, int upper){
    List<Recipe> tempList = new List<Recipe>.from(this.list);
    var i = lower;
    var bigger = upper;
    var smaller = lower;
    var pivot = this.list[pivotIndex];
    while(i<=upper){
      if(this.list[i].title.compareTo(pivot.title) <= 0 && i != pivotIndex)
      {
        tempList[smaller] = this.list[i];
        smaller += 1;
      }else if (this.list[i].title.compareTo(pivot.title) > 0)
      {
        tempList[bigger] = this.list[i];
        bigger -= 1;
      }
      i += 1;
    }
    pivotIndex = smaller;
    tempList[smaller] = pivot;
    this.list = tempList;
    return pivotIndex;
  }


}