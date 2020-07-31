import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:exattraffic/models/marker_model.dart';

abstract class MarkerEvent extends Equatable {
  MarkerEvent();

  @override
  List<Object> get props => [];
}

class ClickTollPlaza extends MarkerEvent {
  final MarkerModel marker;

  ClickTollPlaza({@required this.marker});

  @override
  List<Object> get props => [marker];
}