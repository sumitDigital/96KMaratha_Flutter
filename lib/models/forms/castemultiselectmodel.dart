class CasteMultiSelectModel {
  int? id;
  int? foreignKey;
  String? name;

  CasteMultiSelectModel({this.id, this.foreignKey, this.name});

  CasteMultiSelectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foreignKey = json['ForeignKey'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ForeignKey'] = foreignKey;
    data['name'] = name;
    return data;
  }
}
