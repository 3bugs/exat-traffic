import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class AppEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMarker extends AppEvent {}
