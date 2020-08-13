import 'package:equatable/equatable.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/screens/home/home.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

enum MapTool { none, layer, aroundMe, schematicMaps, currentLocation }

abstract class HomeState extends Equatable {
  final MapTool selectedMapTool;
  final List<MarkerModel> markerList;
  final List<CategoryModel> categoryList;
  //final Map<int, bool> categorySelectedMap;
  final bool showProgress;
  final DateTime dateTime = new DateTime.now();

  HomeState({
    @required this.selectedMapTool,
    @required this.markerList,
    @required this.categoryList,
    @required this.showProgress,
    //@required this.categorySelectedMap,
  });

  @override
  List<Object> get props => [selectedMapTool, markerList, categoryList, showProgress, dateTime];
}

class Initial extends HomeState {
  Initial({
    @required selectedMapTool,
    @required markerList,
    @required categoryList,
    @required showProgress,
    //@required categorySelectedMap,
  }) : super(
          selectedMapTool: selectedMapTool,
          markerList: markerList,
          categoryList: categoryList,
          showProgress: showProgress,
          //categorySelectedMap: categorySelectedMap,
        );
}

class MapToolChange extends HomeState {
  MapToolChange({
    @required selectedMapTool,
    @required markerList,
    @required categoryList,
    @required showProgress,
    //@required categorySelectedMap,
  }) : super(
          selectedMapTool: selectedMapTool,
          markerList: markerList,
          categoryList: categoryList,
          showProgress: showProgress,
          //categorySelectedMap: categorySelectedMap,
        );
}

class MarkerLayerChange extends HomeState {
  MarkerLayerChange({
    @required selectedMapTool,
    @required markerList,
    @required categoryList,
    @required showProgress,
    //@required categorySelectedMap,
  }) : super(
          selectedMapTool: selectedMapTool,
          markerList: markerList,
          categoryList: categoryList,
          showProgress: showProgress,
          //categorySelectedMap: categorySelectedMap,
        );
}

class ShowProgressChange extends HomeState {
  ShowProgressChange({
    @required selectedMapTool,
    @required markerList,
    @required categoryList,
    @required showProgress,
    //@required categorySelectedMap,
  }) : super(
    selectedMapTool: selectedMapTool,
    markerList: markerList,
    categoryList: categoryList,
    showProgress: showProgress,
    //categorySelectedMap: categorySelectedMap,
  );
}
