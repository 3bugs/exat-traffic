import 'dart:async';
import 'package:exattraffic/models/category_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bloc/bloc.dart';

import 'package:exattraffic/screens/home/bloc/bloc.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/services/google_maps_services.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/models/alert_model.dart';
import 'package:exattraffic/models/marker_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final List<MarkerModel> markerList;
  final List<CategoryModel> categoryList;
  Map<int, bool> categorySelectedMap = Map();

  HomeBloc({
    @required this.markerList,
    @required this.categoryList,
  }) : super(MapToolChange(
          selectedMapTool: MapTool.none,
          markerList: List<MarkerModel>(),
          categoryList: List<CategoryModel>(),
          categorySelectedMap: Map<int, bool>(),
        )) {
    print('******************** Category List ********************');
    categoryList.forEach((category) {
      print('- Name: ${category.name}, Bitmap: ${category.markerIconBitmap}');

      // เริ่มต้น กำหนดให้แสดง marker ทุกประเภท
      categorySelectedMap[category.code] = true;
    });
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    final currentState = state;

    if (event is ClickMapTool) {
      //if (currentState is MapToolChange) {
      if (currentState.selectedMapTool == MapTool.none) {
        yield MapToolChange(
          selectedMapTool: event.mapTool,
          markerList: markerList,
          categoryList: categoryList,
          categorySelectedMap: categorySelectedMap,
        );
      } else {
        if (currentState.selectedMapTool == MapTool.layer) {
          yield MapToolChange(
            selectedMapTool: event.mapTool == MapTool.layer ? MapTool.none : MapTool.aroundMe,
            markerList: event.mapTool == MapTool.layer
                ? List<MarkerModel>()
                : markerList.where((marker) => marker.id > 250).toList(),
            categoryList: categoryList,
            categorySelectedMap: categorySelectedMap,
          );
        } else {
          yield MapToolChange(
            selectedMapTool: event.mapTool == MapTool.aroundMe ? MapTool.none : MapTool.layer,
            markerList: event.mapTool == MapTool.aroundMe ? List<MarkerModel>() : markerList,
            categoryList: categoryList,
            categorySelectedMap: categorySelectedMap,
          );
        }
      }
      return;
      //}
    } else if (event is ClickMarkerLayer) {
      print('********** YIELD MarkerLayerChange');

      CategoryModel clickedCategory = event.category;
      categorySelectedMap[clickedCategory.code] = !categorySelectedMap[clickedCategory.code];

      List<MarkerModel> tempMarkerList =
          markerList.where((marker) => categorySelectedMap[marker.category.code]).toList();

      categorySelectedMap = Map.from(categorySelectedMap);

      yield MarkerLayerChange(
        selectedMapTool: state.selectedMapTool,
        markerList: tempMarkerList, // todo: *****
        categoryList: categoryList,
        categorySelectedMap: categorySelectedMap,
      );
    }
  }
}
