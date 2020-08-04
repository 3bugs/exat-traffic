import 'package:flutter/cupertino.dart';

class CoreConfigModel {
  final int id;
  final String code;
  final String value;
  final String name;

  CoreConfigModel({
    @required this.id,
    @required this.code,
    @required this.value,
    @required this.name,
  });

  factory CoreConfigModel.fromJson(Map<String, dynamic> json) {
    return CoreConfigModel(
      id: json['id'],
      code: json['code'],
      value: json['value'],
      name: json['name'],
    );
  }

  @override
  String toString() {
    return 'ID: $id, Code: $code, Value: $value, Name: $name';
  }
}
