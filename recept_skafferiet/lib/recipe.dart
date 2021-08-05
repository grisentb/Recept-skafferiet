class Recipe {
  List<String> instructions;
  List<String> ingredients;
  var title;
  var id;
  var url;
  var extra;
  var portions;
  var image;

  Recipe(tit, ing, ins, ext, url, por, img) {
    
    this.title = tit;
    this.ingredients = ing;
    this.instructions = ins;
    this.extra = ext;
    this.url = url;
    this.portions = por;
    this.image = img;
  }

  //getters and setters
  getIngredients() {
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

  getExtra() {
    return this.extra;
  }

  getPortions() {
    return this.portions;
  }

  getImage() {
    return this.image;
  }
}
