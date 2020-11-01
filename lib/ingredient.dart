class Ingredient{
  double _quantite;
  String _name;
  String _picture;

  Ingredient();

  Ingredient.getAll(this._quantite, this._name, this._picture);

  String get picture => _picture;

  set picture(String value) {
    _picture = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  double get quantite => _quantite;

  set quantite(double value) {
    _quantite = value;
  }

  Map<String, dynamic> toJson() =>
      {
        'quantite': quantite,
        'nom': name,
        'image': picture,
      };

  Map<String, dynamic> toJsonDatabase() =>
      {
        'nom': name,
        'image': picture,
      };

}