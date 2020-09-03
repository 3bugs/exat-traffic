import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/home/bloc/bloc.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BuildContext _context;
  final List<MarkerModel> markerList;
  final List<CategoryModel> categoryList;
  Position userPosition;

  //Map<int, bool> categorySelectedMap = Map();

  HomeBloc(
    this._context, {
    @required this.markerList,
    @required this.categoryList,
  }) : super(Initial(
          selectedMapTool: MapTool.none,
          markerList: List<MarkerModel>(),
          categoryList: categoryList,
          showProgress: false,
          //categorySelectedMap: _getInitialMap(categoryList),
        ));

  static Map<int, bool> _getInitialMap(List<CategoryModel> categoryList) {
    Map<int, bool> tempMap = Map();

    print('******************** Category List ********************');
    categoryList.forEach((category) {
      print('- Name: ${category.name}, Bitmap: ${category.markerIconBitmap}');

      // เริ่มต้น กำหนดให้แสดง marker ทุกประเภท
      tempMap[category.code] = true;
    });
    return tempMap;
  }

  Future<List<MarkerModel>> _getFilterMarkerList({
    @required List<MarkerModel> markerList,
    //@required Map<int, bool> categorySelectedMap,
    @required bool nearbyMode,
    @required Position userPosition,
  }) async {
    // filter by layer (category)
    List<MarkerModel> tempMarkerList =
        markerList.where((marker) => marker.category.selected).toList();

    // filter by nearby
    if (nearbyMode) {
      List<MarkerModel> tempList = List();

      if (userPosition != null) {
        for (int i = 0; i < tempMarkerList.length; i++) {
          MarkerModel marker = tempMarkerList[i];
          double distanceInMeters = await Geolocator().distanceBetween(
            marker.latitude,
            marker.longitude,
            userPosition.latitude,
            userPosition.longitude,
          );
          if (distanceInMeters < 5000) {
            tempList.add(marker);
          }
        }
      } else {
        showMyDialog(
          _context,
          Constants.Message.LOCATION_NOT_AVAILABLE,
          [DialogButtonModel(text: "OK", value: DialogResult.yes)],
        );
      }

      tempMarkerList = tempList;
    }

    return tempMarkerList;
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    final currentState = state;
    final currentShowProgress = currentState.showProgress;
    //final categorySelectedMap = currentState.categorySelectedMap;

    if (event is ClickMapTool &&
        event.mapTool == MapTool.none &&
        currentState.selectedMapTool != MapTool.none) {
      yield MapToolChange(
        selectedMapTool: MapTool.none,
        markerList: List<MarkerModel>(),
        categoryList: categoryList,
        showProgress: currentShowProgress,
      );

      return;
    }

    if (event is ClickMapTool &&
        event.mapTool == MapTool.aroundMe &&
        currentState.selectedMapTool != MapTool.aroundMe) {
      yield ShowProgressChange(
        selectedMapTool: currentState.selectedMapTool,
        markerList: currentState.markerList,
        categoryList: currentState.categoryList,
        showProgress: true,
      );

      userPosition = await getCurrentLocationNotNull();

      yield ShowProgressChange(
        selectedMapTool: currentState.selectedMapTool,
        markerList: currentState.markerList,
        categoryList: currentState.categoryList,
        showProgress: false,
      );
    }

    if (event is ClickMapTool) {
      //if (currentState is Initial) {
      if (currentState.selectedMapTool == MapTool.none) {
        yield MapToolChange(
          selectedMapTool: event.mapTool,
          markerList: await _getFilterMarkerList(
            markerList: markerList,
            //categorySelectedMap: categorySelectedMap,
            nearbyMode: event.mapTool == MapTool.aroundMe,
            userPosition: userPosition,
          ),
          categoryList: categoryList,
          showProgress: currentShowProgress,
          //categorySelectedMap: categorySelectedMap,
        );
      } else {
        if (currentState.selectedMapTool == MapTool.layer) {
          // สถานะเดิมคือ layer
          yield MapToolChange(
            selectedMapTool: event.mapTool == MapTool.layer ? MapTool.none : MapTool.aroundMe,
            markerList: event.mapTool == MapTool.layer
                ? List<MarkerModel>() // กด layer ซ้ำ
                : await _getFilterMarkerList(
                    // กด around me
                    markerList: markerList,
                    //categorySelectedMap: categorySelectedMap,
                    nearbyMode: true,
                    userPosition: userPosition,
                  ),
            categoryList: categoryList,
            showProgress: currentShowProgress,
            //categorySelectedMap: categorySelectedMap,
          );
        } else {
          // สถานะเดิมคือ around me
          yield MapToolChange(
            selectedMapTool: event.mapTool == MapTool.aroundMe ? MapTool.none : MapTool.layer,
            markerList: event.mapTool == MapTool.aroundMe
                ? List<MarkerModel>() // กด around me ซ้ำ
                : await _getFilterMarkerList(
                    // กด layer
                    markerList: markerList,
                    //categorySelectedMap: categorySelectedMap,
                    nearbyMode: false,
                    userPosition: userPosition,
                  ),
            categoryList: categoryList,
            showProgress: currentShowProgress,
            //categorySelectedMap: categorySelectedMap,
          );
        }
      }
      return;
      //}
    } else if (event is ClickMarkerLayer) {
      print('********** YIELD MarkerLayerChange');

      CategoryModel clickedCategory = event.category;

      clickedCategory.selected = !clickedCategory.selected;

      /*List<CategoryModel> newCategoryList = currentState.categoryList.map((category) =>
          category.copyWith(
            selected: category.id == clickedCategory.id ? !category.selected : category.selected,
          )
      ).toList();*/

      //categorySelectedMap[clickedCategory.code] = !categorySelectedMap[clickedCategory.code];

      yield MarkerLayerChange(
        selectedMapTool: state.selectedMapTool,
        markerList: await _getFilterMarkerList(
          markerList: markerList,
          //categorySelectedMap: categorySelectedMap,
          nearbyMode: state.selectedMapTool == MapTool.aroundMe,
          userPosition: userPosition,
        ),
        categoryList: categoryList,
        showProgress: currentShowProgress,
        //categorySelectedMap: categorySelectedMap,
      );
    }
  }
}
