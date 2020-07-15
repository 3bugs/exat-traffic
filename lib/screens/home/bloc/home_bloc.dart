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

  HomeBloc({
    @required this.markerList,
    @required this.categoryList,
  }) : super(MapToolChange(selectedMapTool: MapTool.none));

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    final currentState = state;

    if (event is ClickMapTool) {
      if (currentState is MapToolChange) {
        if (currentState.selectedMapTool == MapTool.none) {
          yield MapToolChange(
            selectedMapTool: event.mapTool,
            markerList: [],
          );
        } else if (currentState.selectedMapTool == MapTool.layer) {
          yield MapToolChange(
            selectedMapTool: event.mapTool == MapTool.layer ? MapTool.none : MapTool.aroundMe,
            markerList: markerList,
          );
        } else {
          yield MapToolChange(
            selectedMapTool: event.mapTool == MapTool.aroundMe ? MapTool.none : MapTool.layer,
            markerList: markerList.where((marker) => marker.id > 200).toList(),
          );
        }
        return;
      }
      if (currentState is HomeState) {
        yield MapToolChange(selectedMapTool: MapTool.none);
        return;
      }
    }
  }
}
