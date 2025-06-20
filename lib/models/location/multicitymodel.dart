import 'package:_96kuliapp/models/forms/cityfkmodel.dart';

class MultiCityModel {
  int? id;
  String? name;
  List<MultiCityFKModel>? value;

  MultiCityModel({this.id, this.name, this.value});

  MultiCityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['value'] != null) {
      value = <MultiCityFKModel>[];
      json['value'].forEach((v) {
        value!.add(MultiCityFKModel.fromJson(v));
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
