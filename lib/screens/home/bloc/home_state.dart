import 'package:equatable/equatable.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

enum MapTool { none, layer, aroundMe }

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class MapToolChange extends HomeState {
  final MapTool selectedMapTool;
  final List<MarkerModel> markerList;

  const MapToolChange({
    @required this.selectedMapTool,
    @required this.markerList,
  });

  @override
  List<Object> get props => [selectedMapTool, markerList];
}
