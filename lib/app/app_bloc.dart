import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  List<MarkerModel> _markerList;
  List<CategoryModel> _categoryList;
  Map<int, BitmapDescriptor> _markerIconMap = Map();

  AppBloc() : super(FetchMarkerInitial()) {
    _loadMarkerIcons();
  }

  List<MarkerModel> get markerList => _markerList;

  List<CategoryModel> get categoryList => _categoryList;

  void _loadMarkerIcons() {
    String basedPath = "assets/images/map_markers";
    Map<int, String> categoryMap = {
      CategoryType.TOLL_PLAZA: "$basedPath/ic_marker_toll_plaza_small.png",
      CategoryType.CCTV: "$basedPath/ic_marker_cctv_small.png",
      CategoryType.POLICE_STATION: "$basedPath/ic_marker_police_station_small.png",
      CategoryType.REST_AREA: "$basedPath/ic_marker_rest_area_small.png",
      CategoryType.U_TURN: "$basedPath/ic_marker_uturn_small.png",
      CategoryType.EAST_PASS: "$basedPath/ic_marker_easy_pass_small.png",
      CategoryType.ENTRANCE: "$basedPath/ic_marker_entrance_small.png",
      CategoryType.EXIT: "$basedPath/ic_marker_exit_small.png",
    };

    categoryMap.forEach((categoryId, filePath) {
      BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        filePath,
      ).then((bitmap) {
        CategoryModel.categoryIconMap[categoryId] = bitmap;
      });
    });
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    final currentState = state;

    if (event is FetchMarker) {
      try {
        _categoryList = await ExatApi.fetchCategories(event.context);

        List<MarkerModel> tempMarkerList = await ExatApi.fetchMarkers(event.context);
        tempMarkerList.forEach((marker) {
          setMarkerCategory(marker);
        });
        // filter เฉพาะ marker ที่อยู่ใน category ที่มี
        _markerList = tempMarkerList.where((marker) => marker.category != null).toList();

        _markerList.forEach((marker) {
          print(
              "***** MARKER [${marker.name}] - lat: ${marker.latitude}, lng: ${marker.longitude}");
        });

        yield FetchMarkerSuccess(markerList: markerList);
      } catch (e) {
        yield FetchMarkerFailure(message: e.toString());
      }
    }
  }

  void setMarkerCategory(MarkerModel marker) {
    if (_categoryList != null) {
      List filteredCategoryList =
          _categoryList.where((category) => category.id == marker.categoryId).toList();
      if (filteredCategoryList.length > 0) {
        marker.category = filteredCategoryList[0];
        print('CATEGORY SET: ${marker.name}');
      } else {
        print('CATEGORY NOT SET: ${marker.name}');
      }
    }
  }
}
