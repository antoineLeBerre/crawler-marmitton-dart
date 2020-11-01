import 'package:crawler_marmiton/ingredient.dart';
import 'package:crawler_marmiton/ustensile.dart';

class Recette{
  String _id;
  String _url;
  String _title;
  String _typePlat;
  List<String> _tags;
  List<String> _urlPictures;
  String _tempsGlobal;
  bool _personne;
  int _quantite;
  String _difficulty;
  String _price;
  List<Ingredient> _ingredients;
  List<Ustensile> _ustensiles;
  String _tempsPreparation;
  String _tempsCuisson;
  List<String> _instructions;

  Recette();

  Recette.getAll(
      this._id,
      this._url,
      this._title,
      this._typePlat,
      this._tags,
      this._urlPictures,
      this._tempsGlobal,
      this._personne,
      this._quantite,
      this._difficulty,
      this._price,
      this._ingredients,
      this._ustensiles,
      this._tempsPreparation,
      this._tempsCuisson,
      this._instructions);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get typePlat => _typePlat;

  set typePlat(String value) {
    _typePlat = value;
  }

  List<String> get tags => _tags;

  set tags(List<String> value) {
    _tags = value;
  }

  List<String> get urlPictures => _urlPictures;

  set urlPictures(List<String> value) {
    _urlPictures = value;
  }

  String get tempsGlobal => _tempsGlobal;

  set tempsGlobal(String value) {
    _tempsGlobal = value;
  }

  bool get personne => _personne;

  set personne(bool value) {
    _personne = value;
  }

  int get quantite => _quantite;

  set quantite(int value) {
    _quantite = value;
  }

  String get difficulty => _difficulty;

  set difficulty(String value) {
    _difficulty = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  List<Ingredient> get ingredients => _ingredients;

  set ingredients(List<Ingredient> value) {
    _ingredients = value;
  }

  List<String> get instructions => _instructions;

  set instructions(List<String> value) {
    _instructions = value;
  }

  String get tempsCuisson => _tempsCuisson;

  set tempsCuisson(String value) {
    _tempsCuisson = value;
  }

  String get tempsPreparation => _tempsPreparation;

  set tempsPreparation(String value) {
    _tempsPreparation = value;
  }

  List<Ustensile> get ustensiles => _ustensiles;

  set ustensiles(List<Ustensile> value) {
    _ustensiles = value;
  }

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'url' : url,
        'title' : title,
        'type' : typePlat,
        'tags' : tags,
        'picture' : urlPictures,
        'temps' : tempsGlobal,
        'personne' : personne,
        'quantite' : quantite,
        'difficulte' : difficulty,
        'prix' : price,
        'ingredients' : ingredientsToJson(),
        'ustensiles' : ustensileToJson(),
        'preparation' : tempsPreparation,
        'cuisson' : tempsCuisson,
        'instruction' : instructions,
      };

  List<dynamic> ingredientsToJson(){
    List<dynamic> ingredientsToJson = [];
    ingredients.forEach((ingredient) {
      ingredientsToJson.add(ingredient.toJson());
    });
    return ingredientsToJson;
  }

  List<dynamic> ustensileToJson(){
    List<dynamic> ustensileToJson = [];
    ustensiles.forEach((ustensile) {
      ustensileToJson.add(ustensile.toJson());
    });
    return ustensileToJson;
  }
}