import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';

class NestedFieldsModel {
  int? id;
  String? name;
  List<FieldModel>? value;

  NestedFieldsModel({this.id, this.name, this.value});

  NestedFieldsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['value'] != null) {
      value = <FieldModel>[];
      json['value'].forEach((v) {
        value!.add(FieldModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (value != null) {
      data['value'] = value!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
