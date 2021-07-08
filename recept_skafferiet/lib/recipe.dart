class Recipe {
  var instructions;
  var ingredients;
  var title;
  var id;
  var url;
  var rating;
  var time;

  Recipe(tit, ing, ins, tim, url) {
    this.title = tit;
    this.ingredients = ing;
    this.instructions = ins;
    this.time = time;
    this.url = url;
  }

  //getters and setters
  getIngridients() {
    return this.ingredients;
  }

  getInstructions() {
    return this.instructions;
  }

  getTitle() {
    return this.title;
  }

  getId() {
    return this.id;
  }

  getUrl() {
    return this.url;
  }

  getRating() {
    return this.rating;
  }

  getTime() {
    return this.time;
  }
}
