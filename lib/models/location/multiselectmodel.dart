import 'package:_96kuliapp/models/forms/StateModel.dart';

class MultiSelectModel {
  int? id;
  String? name;
  String? serchkey;
  List<StateModel>? value;

  MultiSelectModel({this.id, this.name, this.serchkey, this.value});

  MultiSelectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    serchkey = json['serchkey'];
    if (json['value'] != null) {
      value = <StateModel>[];
      json['value'].forEach((v) {
        value!.add(StateModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['serchkey'] = serchkey;
    if (value != null) {
      data['value'] = value!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
