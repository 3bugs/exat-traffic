import 'package:flutter/cupertino.dart';

class CoreConfigModel {
  final int id;
  final String code;
  final String value;

  CoreConfigModel({
    @required this.id,
    @required this.code,
    @required this.value,
  });

  factory CoreConfigModel.fromJson(Map<String, dynamic> json) {
    return CoreConfigModel(
      id: json['id'],
      code: json['code'],
      value: json['value'],
    );
  }

  @override
  String toString() {
    return 'ID: $id, Code: $code, Value: $value';
  }
}
