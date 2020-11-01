import 'package:crawler_marmiton/database.dart';
import 'package:crawler_marmiton/recette.dart';
import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'; // Contains DOM related classes for extracting data from elements


import 'ingredient.dart';
import 'ustensile.dart';

Document document = Document();
Recette recette;
int countRecette = 0;
int countRecetteFail = 0;

Future<void> initiate() async {
  var start = DateTime.now();
  await crawlRecette();
  print(start);
  print(DateTime.now());
}

Future<void> crawlRecette() async {
  Client client = Client();

  int pageNumber = 1;
  String typeRecette = '';

  while(true){
    String url = 'https://www.marmiton.org/recettes/?$typeRecette'
        'page=$pageNumber';
    Response response = await client.get(url);
    Document document = parse(response.body);
    
    List<Element> elements = document.getElementsByClassName('recipe-card-link');
    if(elements.isEmpty) {
      switch(typeRecette){
        case '':
          typeRecette = 'type=platprincipal&';
          pageNumber = 1;
          continue;
        case 'type=platprincipal&':
          typeRecette = 'type=dessert&';
          pageNumber = 1;
          continue;
        case 'type=dessert&':
          typeRecette = 'type=accompagnement&';
          pageNumber = 1;
          continue;
        case 'type=accompagnement&':
          break;
      }
      break;
    }
    for(Element element in elements) {
      Recette recette = await getRecette(element.attributes['href']);
      if(recette != null) {
        countRecette++;
        await setResette(recette);
      }
    };
    pageNumber++;
  }
}

void crawlIngredient() {

}

void crawlUstensile() {

}

Future<Recette> getRecette(String url) async {
  Client client = Client();
  recette = Recette();
  print(url);

  try {
    Response response = await client.get(url);

    document = parse(response.body);
    recette.url = url;
    createRecette();
    return recette;
  } on FormatException {
    return null;
  }
  // await setResette(recette);
}

void createRecette(){
  recette.id = getId(recette.url);
  recette.title = getString('title');
  recette.tags = getList('tags');
  recette.typePlat = recette.tags[0];
  recette.urlPictures = getUrlPictures();
  recette.tempsGlobal = getString('global');
  recette.tempsPreparation = getString('preparation');
  recette.tempsCuisson = getString('cuisson');
  recette.quantite = getQuantite();
  recette.difficulty = getString('difficulty');
  recette.price = getString('price');
  recette.ingredients = getIngredients();
  recette.ustensiles = getUstensiles();
  recette.instructions = getList('instructions');
}

String getId(String url){
  List<String> urlSplit = url.split('/');
  List<String> recetteSplit = urlSplit[urlSplit.length - 1].split('_');
  List<String> idSplit = recetteSplit[recetteSplit.length - 1].split('.');
  return idSplit[0];
}

String getString(String value){
  String selector;
  switch(value){
    case 'title':
      selector = 'h1.main-title';
      break;
    case 'global':
      selector = '.recipe-infos__timmings > '
          '.recipe-infos__timmings__total-time';
      break;
    case 'preparation':
      selector = '.recipe-infos__timmings__detail > '
          '.recipe-infos__timmings__preparation';
      break;
    case 'cuisson':
      selector = '.recipe-infos__timmings__cooking > '
          '.recipe-infos__timmings__value';
      break;
    case 'difficulty':
      selector = '.recipe-infos__level > .recipe-infos__item-title';
      break;
    case 'price':
      selector = '.recipe-infos__budget > .recipe-infos__item-title';
      break;
  }

  Element element = document.querySelector(selector);
  if(element == null){
    return '';
  }
  String elementTemps = element.text.trim();
  int indexTime = elementTemps.indexOf(':');

  return elementTemps.substring(indexTime+1).trim();
}

List<String> getList(String value){
  List<String> list = [];
  String selector = '';
  switch(value){
    case 'tags':
      selector = 'ul.mrtn-tags-list > li.mrtn-tag';
      break;
    case 'instructions':
      selector = '.recipe-preparation__list > li';
      break;
  }
  List<Element> elements = document.querySelectorAll(selector);
  for(Element element in elements){
    String text = element.text;
    if(element == null){
      Element aTag = element.children as Element;
      text = aTag.text;
    }
    list.add(text.trim());
  }

  return list;
}

List<String> getUrlPictures(){
  List<Element> elements = document.querySelectorAll('div'
      '.recipe-media-viewer-thumbnail-container > picture > img'
      '.recipe-media-viewer-picture');
  List<String> urlElement = [];
  for(Element element in elements){
    urlElement.add(element.attributes['data-src']);
  }

  return urlElement;
}

int getQuantite(){
  Element element = document.querySelector('.recipe-infos > .recipe-infos__quantity');
  if(element == null){
    recette.personne = false;
    return -1;
  }
  List<Element> children = element.children;
  recette.personne = children[0].text.toLowerCase() == 'personnes';
  int nombreQuantite = int.parse(children[1].text.trim());

  return nombreQuantite;
}

List<Ingredient> getIngredients(){
  List<Element> elements = document.querySelectorAll
    ('.recipe-ingredients__list > li');
  List<Ingredient> ingredients = [];
  for(Element element in elements){
    Ingredient ingredient = getIngredient(element);
    ingredients.add(ingredient);
  }

  return ingredients;
}


Ingredient getIngredient(Element element){
  Ingredient ingredient = Ingredient();

  List<Element> elements = element.children;
  if(elements.length == 1){
    elements = elements[0].children;
  }
  List<Element> picture = elements[0].getElementsByTagName('img');
  ingredient.picture = picture[0].attributes['data-src'];

  List<Element> spenElements = elements[1].getElementsByTagName('span');
  ingredient.quantite = 0;
  if(spenElements[0].text.isNotEmpty){
    if(spenElements[0].text.contains('/')){
      List<String> numbers = spenElements[0].text.split('/');
      ingredient.quantite = double.parse(numbers[0]) / double.parse(numbers[1]);
    }
    else {
      ingredient.quantite = double.parse(spenElements[0].text);
    }
  }

  String name = spenElements[1].text.trim();
  String facultatif = (spenElements[2].text.contains('facultatif'))? spenElements[2].text.trim() : '';
  ingredient.name = '$name $facultatif'.trim();

  return ingredient;
}

List<Ustensile> getUstensiles(){
  List<Element> elements = document.querySelectorAll
    ('.recipe-utensils__list > li > a');
  List<Ustensile> ustensiles = [];
  for(Element element in elements){
    List<Element> picture = element.children[0].getElementsByTagName('img');
    String photo = picture[0].attributes['data-src'];

    List<Element> ustensileText = element.children[1].children;
    String ustensileName = ustensileText[0].text.trim();
    Ustensile ustensile = Ustensile.getAll(photo, ustensileName);
    ustensiles.add(ustensile);
  }

  return ustensiles;
}