import 'package:exattraffic/screens/home/bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class HomeEvent extends Equatable {
  HomeEvent();

  @override
  List<Object> get props => [];
}

class ClickMapTool extends HomeEvent {
  final MapTool mapTool;

  ClickMapTool({@required this.mapTool});
}