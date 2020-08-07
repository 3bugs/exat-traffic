import 'package:flutter/material.dart';

class ExpressWayModel {
  ExpressWayModel({
    @required this.id,
    @required this.name,
    @required this.image,
  });

  final int id;
  final String name;
  final AssetImage image;

  factory ExpressWayModel.fromJson(Map<String, dynamic> json) {
    return ExpressWayModel(
      id: json['id'],
      name: json['name'],
      image: json['cover'],
    );
  }

  @override
  String toString() {
    return 'ID: ${this.id}, Name: ${this.name}, Image: ${this.image}';
  }
}
