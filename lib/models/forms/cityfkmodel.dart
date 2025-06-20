class MultiCityFKModel {
  int? id;
  String? name;
  String? serchkey;
  int? foreignKey;
  int? subForeignKey;

  MultiCityFKModel({this.id, this.name, this.foreignKey, this.subForeignKey});

  MultiCityFKModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    serchkey = json['serchkey'];
    foreignKey = json['foreign_key'];
    subForeignKey = json['sub_foreign_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['serchkey'] = serchkey;
    data['foreign_key'] = foreignKey;
    data['sub_foreign_key'] = subForeignKey;
    return data;
  }
}
