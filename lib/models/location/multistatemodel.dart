import 'package:_96kuliapp/models/forms/statefkmodel.dart';

class MultiStateModel {
  final int? id;
  final String? name;
  final List<StatefkModel>? value;

  MultiStateModel({this.id, this.name, this.value});

  factory MultiStateModel.fromJson(Map<String, dynamic> json) {
    return MultiStateModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      value: (json['value'] as List<dynamic>?)
          ?.map((e) => StatefkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
