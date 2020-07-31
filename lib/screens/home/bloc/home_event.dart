import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/screens/home/bloc/bloc.dart';

abstract class HomeEvent extends Equatable {
  HomeEvent();

  @override
  List<Object> get props => [];
}

class ClickMapTool extends HomeEvent {
  final MapTool mapTool;

  ClickMapTool({@required this.mapTool});

  @override
  List<Object> get props => [mapTool];
}

class ClickMarkerLayer extends HomeEvent {
  final CategoryModel category;

  ClickMarkerLayer({@required this.category});

  @override
  List<Object> get props => [category];
}