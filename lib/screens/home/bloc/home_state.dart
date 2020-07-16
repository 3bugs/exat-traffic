import 'package:equatable/equatable.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

enum MapTool { none, layer, aroundMe }

abstract class HomeState extends Equatable {
  final MapTool selectedMapTool;
  final List<MarkerModel> markerList;
  final List<CategoryModel> categoryList;
  final Map<int, bool> categorySelectedMap;

  const HomeState({
    @required this.selectedMapTool,
    @required this.markerList,
    @required this.categoryList,
    @required this.categorySelectedMap,
  });

  @override
  List<Object> get props => [selectedMapTool, markerList, categoryList, categorySelectedMap];
}

class MapToolChange extends HomeState {
  const MapToolChange({
    @required selectedMapTool,
    @required markerList,
    @required categoryList,
    @required categorySelectedMap,
  }) : super(
          selectedMapTool: selectedMapTool,
          markerList: markerList,
          categoryList: categoryList,
          categorySelectedMap: categorySelectedMap,
        );
}

class MarkerLayerChange extends HomeState {
  const MarkerLayerChange({
    @required selectedMapTool,
    @required markerList,
    @required categoryList,
    @required categorySelectedMap,
  }) : super(
          selectedMapTool: selectedMapTool,
          markerList: markerList,
          categoryList: categoryList,
          categorySelectedMap: categorySelectedMap,
        );
}
