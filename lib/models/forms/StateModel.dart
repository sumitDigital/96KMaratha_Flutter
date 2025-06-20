class StateModel {
  int? id;
  String? name;
  String? serchkey;

  StateModel({this.id, this.name, this.serchkey});

  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    serchkey = json['serchkey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['serchkey'] = serchkey;

    return data;
  }
}
