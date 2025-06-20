class FieldModel {
  int? id;
  String? name;
  String? serchkey;

  FieldModel({this.id, this.name, this.serchkey});

  FieldModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    serchkey = json['serchkey']; // Must be here
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serchkey': serchkey,
    };
  }
}
