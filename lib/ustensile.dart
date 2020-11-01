class Ustensile{
  String _picture;
  String _name;

  Ustensile();

  Ustensile.getAll(String ustensilePicture, String ustensileName){
    _picture = ustensilePicture;
    _name = ustensileName;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get picture => _picture;

  set picture(String value) {
    _picture = value;
  }

  Map<String, dynamic> toJson() =>
      {
        'nom': name,
        'image': picture,
      };
  Map<String, dynamic> toJsonDatabase() =>
      {
        'nom': name.substring(2),
        'image': picture,
      };
}