import 'package:flutter/material.dart';

class IncidentModel {
  IncidentModel({
    @required this.name,
    @required this.description,
    @required this.date,
    @required this.image,
  });

  final String name;
  final String description;
  final String date;
  final NetworkImage image;
}