class Recipe {
  var instructions;
  var ingridients;
  var title;
  var description;
  var id;
  var url;
  var rating;
  var time;

  Recipe(ins, ing, tit, des) {
    this.ingridients = ing;
    this.instructions = ins;
    this.title = tit;
    this.description = des;
  }

  //getters and setters
  getIngridients() {
    return this.ingridients;
  }

  getInstructions() {
    return this.instructions;
  }

  getTitle() {
    return this.title;
  }

  getDescription() {
    return this.description;
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
