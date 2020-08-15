import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/screens/search/search_place.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/services/google_maps_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchPlacePresenter extends BasePresenter<SearchPlace> {
  final GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  String searchTerm;
  List<PredictionModel> predictionList = List();
  List<SearchResultModel> searchResultList;
  bool showPredictionList = false;
  Timer callApiTimer;

  SearchPlacePresenter(
    State<SearchPlace> state,
  ) : super(state);

  void search(String text) async {
    String newText = text ?? "";
    newText = newText.trim();

    // ถ้าไม่ดักเงื่อนไขนี้ จะทำให้ prediction list ถูกแสดงเมื่อช่อง search got/lost focus
    if (searchTerm == newText) return;

    setState(() {
      searchTerm = newText;
      showPredictionList = true;
    });

    if (callApiTimer != null) {
      callApiTimer.cancel();
    }
    callApiTimer = Timer(Duration(milliseconds: 1500), () async {
      List<PredictionModel> dataList;

      if (newText.isNotEmpty) {
        Position currentLocation = await getCurrentLocation();
        dataList = await _googleMapsServices.getPlaceAutocomplete(
          newText,
          LatLng(currentLocation.latitude, currentLocation.longitude),
        );
      }

      try {
        setState(() {
          predictionList = dataList ?? List<PredictionModel>();
        });
      } catch (_) {
      }
    });
  }

  void handleClickPredictionItem(
    BuildContext context,
    PredictionModel prediction,
    String dummyPlaceId,
  ) async {
    //alert(context, "EXAT Traffic", prediction.description);
    setState(() {
      showPredictionList = false;
    });

    if (prediction.placeId == dummyPlaceId) {
      // user เลือกค้นหา
      loading();
      List<SearchResultModel> dataList = await _googleMapsServices.getPlaceTextSearch(searchTerm);
      setState(() {
        searchResultList = dataList;
      });
      loaded();
    } else {
      // user เลือก prediction
      underConstruction(context);
    }
  }

  void handleClickSearchResultItem(BuildContext context, SearchResultModel searchResult) {
    //alert(context, "EXAT Traffic", searchResult.placeDetails.name);
    underConstruction(context);
  }
}
