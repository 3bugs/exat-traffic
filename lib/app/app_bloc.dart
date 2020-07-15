import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/services/api.dart';
import 'package:flutter/cupertino.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  List<MarkerModel> _markerList;
  List<CategoryModel> _categoryList;

  AppBloc() : super(FetchMarkerInitial());

  List<MarkerModel> get markerList => _markerList;

  List<CategoryModel> get categoryList => _categoryList;

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    final currentState = state;

    if (event is FetchMarker) {
      try {
        _categoryList = await ExatApi.fetchCategories(event.context);
        _markerList = await ExatApi.fetchMarkers(event.context);
        _markerList.forEach((marker) {
          setMarkerCategory(marker);
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
      }
    }
  }
}
