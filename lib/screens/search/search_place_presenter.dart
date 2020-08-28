import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/screens/search/search_place.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/services/google_maps_services.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/app/bloc.dart';

class SearchPlacePresenter extends BasePresenter<SearchPlace> {
  static const DELAY_SEARCH_MS = 750;

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
    callApiTimer = Timer(Duration(milliseconds: DELAY_SEARCH_MS), () async {
      List<PredictionModel> dataList;

      if (newText.isNotEmpty) {
        Position currentLocation = await getCurrentLocation();
        dataList = await _googleMapsServices.getPlaceAutocomplete(
          newText,
          currentLocation != null
              ? LatLng(currentLocation.latitude, currentLocation.longitude)
              : null,
        );
      }

      try {
        setState(() {
          predictionList = dataList ?? List<PredictionModel>();
        });
      } catch (_) {}
    });
  }

  void handleClickPredictionItem(BuildContext context, PredictionModel prediction) async {
    //alert(context, "555", BlocProvider.of<AppBloc>(context).markerList.length.toString());

    //alert(context, "EXAT Traffic", prediction.description);
    setState(() {
      showPredictionList = false;
    });

    if (prediction.placeId == SearchPlace.DUMMY_PLACE_ID) {
      // user เลือกค้นหา
      loading();
      try {
        List<SearchResultModel> dataList = await _googleMapsServices.getPlaceTextSearch(searchTerm);
        setState(() {
          searchResultList = dataList;
        });
      } catch (error) {}
      loaded();
    } else {
      // user เลือก prediction
      loading();
      try {
        PlaceDetailsModel placeDetails =
            await _googleMapsServices.getPlaceDetails(prediction.placeId);
        /*Position destination =
            Position(latitude: placeDetails.latitude, longitude: placeDetails.longitude);*/
        RouteModel bestRoute = await findBestRoute(state.context, placeDetails);

        if (bestRoute != null) {
          assert(bestRoute.gateInCostTollList.isNotEmpty);
          // กลับไป _handleClickSearchOption ใน MyScaffold
          Navigator.pop(context, bestRoute);
        }
      } catch (error) {}
      loaded();

      /*alert(context, "Place Details",
          "name: ${placeDetails.name}\nformatted address: ${placeDetails.formattedAddress}\nlatitude: ${placeDetails.latitude}\nlongitude: ${placeDetails.longitude}");*/
    }
  }

  void handleClickSearchResultItem(BuildContext context, SearchResultModel searchResult) async {
    loading();
    try {
      /*Position destination = Position(
        latitude: searchResult.placeDetails.latitude,
        longitude: searchResult.placeDetails.longitude,
      );*/
      RouteModel bestRoute = await findBestRoute(state.context, searchResult.placeDetails);

      if (bestRoute != null) {
        assert(bestRoute.gateInCostTollList.isNotEmpty);
        // กลับไป _handleClickSearchOption ใน MyScaffold
        Navigator.pop(context, bestRoute);
      }
    } catch (error) {}
    loaded();
  }

  static Future<RouteModel> findBestRoute(BuildContext context, PlaceDetailsModel destination) async {
    Position origin = await getCurrentLocationNotNull();

    if (origin == null) {
      showMyDialog(
        context,
        Constants.Message.LOCATION_NOT_AVAILABLE,
        [DialogButtonModel(text: "OK", value: DialogResult.yes)],
      );
      return Future.value(null);
    }

    List<GateInCostTollModel> routeList = await MyApi.findRoute(
      origin,
      Position(latitude: destination.latitude, longitude: destination.longitude),
      BlocProvider.of<AppBloc>(context).markerList,
    );

    final GoogleMapsServices googleMapsServices = GoogleMapsServices();

    routeList = await Future.wait<GateInCostTollModel>(
      routeList.map((gateInCostToll) async {
        final List<LatLng> partTollLatLngList = List();

        // เพิ่มด่านทางเข้าใน way points
        partTollLatLngList
            .add(LatLng(gateInCostToll.gateIn.latitude, gateInCostToll.gateIn.longitude));
        // เพิ่มด่านระหว่างทางใน way points
        partTollLatLngList.addAll(
          gateInCostToll.costToll.partTollMarkerList
              .map((markerModel) => LatLng(markerModel.latitude, markerModel.longitude))
              .toList(),
        );
        // เพิ่มทางออกใน way points
        partTollLatLngList
            .add(LatLng(gateInCostToll.costToll.latitude, gateInCostToll.costToll.longitude));

        final Map<String, dynamic> googleRoute = await googleMapsServices.getRoute(
          LatLng(origin.latitude, origin.longitude),
          LatLng(destination.latitude, destination.longitude),
          partTollLatLngList,
        );
        gateInCostToll.googleRoute = googleRoute;

        return gateInCostToll;
      }).toList(),
    );

    //routeList.map((gateInCostToll) => print(gateInCostToll)).toList();
    GateInCostTollModel bestGateInCostToll = routeList.reduce((value, element) =>
        (value.googleRoute['legs'][0]['duration']['value'] <
                element.googleRoute['legs'][0]['duration']['value']
            ? value
            : element));
    //print(bestGateInCostToll);
    return RouteModel(
      origin: PlaceDetailsModel(
        "", // no place id for user's location
        name: "ตำแหน่งปัจจุบันของคุณ",
        formattedAddress: null,
        latitude: origin.latitude,
        longitude: origin.longitude,
      ),
      destination: destination,
      gateInCostToll: bestGateInCostToll,
    );
  }
}
