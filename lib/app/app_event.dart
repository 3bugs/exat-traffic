import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class AppEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMarker extends AppEvent {
  final BuildContext context;

  FetchMarker({@required this.context});
}
