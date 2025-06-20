import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:_96kuliapp/models/forms/StateModel.dart';

class MultiSelectModelCity {
  int? id;
  String? name;
  List<CityModel>? value;

  MultiSelectModelCity({this.id, this.name, this.value});

  MultiSelectModelCity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['value'] != null) {
      value = <CityModel>[];
      json['value'].forEach((v) {
        value!.add(CityModel.fromJson(v));
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
