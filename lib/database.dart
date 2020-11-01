import 'package:crawler_marmiton/ingredient.dart';
import 'package:crawler_marmiton/recette.dart';
import 'package:crawler_marmiton/ustensile.dart';
import 'package:mongo_dart/mongo_dart.dart';

// var database;
//
// Future<void> initiateDB() async {
//   database = await Db.create('mongodb+srv://root:crawlerdev@crawlerdev.blrot.mongodb'
//       '.net/kezkejmange?retryWrites=true&w=majority');
//   await database.open();
// }
//
// Future<void> closeDB() async {
//   await database.close();
// }

Future<void> setResettes(List<Recette> recettes) async {
  var database = await Db.create('mongodb+srv://root:crawlerdev@crawlerdev.blrot.mongodb'
      '.net/kezkejmange?retryWrites=true&w=majority');
  await database.open();

  var collRecette= database.collection('recette');
  List<Map<String, dynamic>> insertRecettes = [];
  for(Recette recette in recettes) {
    var dbIngredient = await collRecette.find(where.eq('id', recette.id)).toList();
    if (dbIngredient.isEmpty) {
      insertRecettes.add(recette.toJson());
    }
  }

  await collRecette.insertAll(insertRecettes);

  await database.close();
}

Future<void> setResette(Recette recette) async {
  try {
    var database = await Db.create('mongodb+srv://root:crawlerdev@crawlerdev.blrot.mongodb'
        '.net/kezkejmange?retryWrites=true&w=majority');
    await database.open();

    var collRecette= database.collection('recette');
    List<Map<String, dynamic>> insertRecettes = [];
    var recetteExist = await collRecette.find(where.eq('id', recette.id)).toList();
    if (recetteExist.isEmpty) {
      await collRecette.insert(recette.toJson());
    }

    await database.close();
  } on ConnectionException {
    await setResette(recette);
  }
}

void setIngredient(Ingredient ingredient) async {
  var database = await Db.create('mongodb+srv://root:crawlerdev@crawlerdev.blrot.mongodb'
      '.net/kezkejmange?retryWrites=true&w=majority');
  await database.open();

  var collIngredient = database.collection('ingredient');
  var dbIngredient = await collIngredient.find(where.eq('nom', ingredient.name)).toList();
  if (dbIngredient.isEmpty){
    await collIngredient.insert(ingredient.toJsonDatabase());
  }

  await database.close();
}

void setUstensile(Ustensile ustensile) async {
  var database = await Db.create('mongodb+srv://root:crawlerdev@crawlerdev.blrot.mongodb'
      '.net/kezkejmange?retryWrites=true&w=majority');
  await database.open();

  var collUstensile = database.collection('ustensile');
  var dbUstensile = await collUstensile.find(where.eq('nom', ustensile.name)).toList();
  if (dbUstensile.isEmpty){
    await collUstensile.insert(ustensile.toJsonDatabase());
  }

  await database.close();
}