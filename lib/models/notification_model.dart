import 'package:flutter/material.dart';

class NotificationModel {
  NotificationModel({
    @required this.name,
    @required this.description,
    @required this.read,
  });

  final String name;
  final String description;
  final bool read;
}