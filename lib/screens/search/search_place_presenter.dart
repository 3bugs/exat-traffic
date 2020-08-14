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
  List<PredictionModel> predictionList;

  SearchPlacePresenter(
    State<SearchPlace> state,
  ) : super(state);

  void search(String text) async {
    Position currentLocation = await getCurrentLocation();
    List<PredictionModel> dataList = await _googleMapsServices.getPlaceAutocomplete(
      text,
      LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    setState(() {
      searchTerm = text;
      predictionList = dataList;
    });
  }
}
