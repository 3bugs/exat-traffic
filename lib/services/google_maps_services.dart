import 'dart:io' show Platform;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/secret.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/locale_text.dart';

final String apiKey =
    Platform.isAndroid ? Secret.GOOGLE_API_KEY_ANDROID : Secret.GOOGLE_API_KEY_IOS;

class GoogleMapsServices {
  final BuildContext _context;

  GoogleMapsServices(this._context);

  // https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyC1e9L1eA1YyOhsKW4-BhhwHD2fgtqWnak&language=th&waypoints=via:13.8133553%2C100.55055219999997%7Cvia:13.660109%2C100.66368499999999%7C&origin=13.7998143,100.4187235&destination=13.56686331,100.937025
  Future<Map<String, dynamic>> getRoute(
    LatLng origin,
    LatLng destination,
    List<LatLng> wayPointList,
    int departureTime,
  ) async {
    // &waypoints=via:-37.81223 %2C 144.96254 %7C via:-34.92788 %2C 138.60008

    String wayPoints = wayPointList.fold("", (String previousValue, LatLng wayPoint) {
      return "${previousValue}via:${wayPoint.latitude}%2C${wayPoint.longitude}%7C";
    });

    Map<String, dynamic> params = Map();
    params["waypoints"] = wayPoints;
    params["origin"] = "${origin.latitude},${origin.longitude}";
    params["destination"] = "${destination.latitude},${destination.longitude}";
    params["departure_time"] = departureTime == 0 ? 'now' : departureTime;

    final ResponseResult result = await _makeRequest("directions", params);
    if (result.success) {
      return result.data["routes"][0];
    } else {
      throw Exception(result.data);
    }

    /*final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&waypoints=$wayPoints&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    //return values["routes"][0]["overview_polyline"]["points"];
    return values["routes"][0];*/
  }

  // https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyC1e9L1eA1YyOhsKW4-BhhwHD2fgtqWnak&language=th&origin=13.7563,100.5018&input=%E0%B8%9A%E0%B8%B2%E0%B8%87
  Future<List<PredictionModel>> getPlaceAutocomplete(String searchTerm, LatLng latLng) async {
    Map<String, dynamic> params = Map();
    params["input"] = searchTerm;
    if (latLng != null) {
      params["origin"] = "${latLng.latitude},${latLng.longitude}";
    }

    final ResponseResult result = await _makeRequest("place/autocomplete", params);
    if (result.success) {
      return result.data["predictions"]
          .map<PredictionModel>((json) => PredictionModel.fromJson(json))
          .toList();
    } else {
      throw Exception(result.data);
    }
  }

  // https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyCrBhuovlx9Wk2v7mQNvCg4JIL_affg0ks&language=th&query=%E0%B8%95.%E0%B8%9A%E0%B8%B2%E0%B8%87%E0%B9%80%E0%B8%A5%E0%B8%99%20%E0%B8%99%E0%B8%84%E0%B8%A3%E0%B8%9B%E0%B8%90%E0%B8%A1
  Future<List<SearchResultModel>> getPlaceTextSearch(String searchTerm) async {
    Map<String, dynamic> params = Map();
    params["query"] = searchTerm;

    final ResponseResult result = await _makeRequest("place/textsearch", params);
    if (result.success) {
      return result.data["results"]
          .map<SearchResultModel>((json) => SearchResultModel.fromJson(json))
          .toList();
    } else {
      throw Exception(result.data);
    }
  }

  // https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyCrBhuovlx9Wk2v7mQNvCg4JIL_affg0ks&language=th&fields=name,formatted_address,geometry,photo&place_id=ChIJPfQYsgug4jARcFDiXbIAAQM
  Future<PlaceDetailsModel> getPlaceDetails(String placeId) async {
    Map<String, dynamic> params = Map();
    params["place_id"] = placeId;
    params["fields"] = "name,formatted_address,geometry,photo";

    final ResponseResult result = await _makeRequest("place/details", params);
    if (result.success) {
      return PlaceDetailsModel.fromJson(placeId, result.data["result"]);
    } else {
      throw Exception(result.data);
    }
  }

  Future<ResponseResult> _makeRequest(String endPoint, Map<String, dynamic> params) async {
    String languageCode = Provider.of<LanguageModel>(_context, listen: false).langCodeGoogleApi;
    String queryParams = "";
    params.forEach((key, value) {
      queryParams += "&$key=$value";
    });
    final String url =
        "https://maps.googleapis.com/maps/api/$endPoint/json?key=$apiKey&language=$languageCode$queryParams";
    http.Response response = await http.get(
      url,
      headers: {"referer": "http://${Platform.isAndroid ? 'android' : 'ios'}.exat.co.th/"},
    );

    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print("Google Maps API: $url");
    print("Google Maps API Response Status Code: ${response.statusCode}");
    print("Google Maps API Response Body: ${response.body}");
    print("Google Maps API Response Body decode: ${json.decode(response.body)}");
    print("-------------------------------------------------------");

    if (response.statusCode == 200) {
      Map<String, dynamic> dataMap = json.decode(response.body);
      if (dataMap['status'] == 'OK' || dataMap['status'] == 'ZERO_RESULTS') {
        return ResponseResult(success: true, data: dataMap);
      } else {
        return ResponseResult(success: false, data: dataMap['error_message']);
      }
    } else {
      String msg = "เกิดข้อผิดพลาดในการเชื่อมต่อ Server";
      return ResponseResult(success: false, data: msg);
    }
  }
}

class PredictionModel {
  final String description;
  final int distanceMeters;
  final String placeId;

  PredictionModel({
    @required this.description,
    @required this.distanceMeters,
    @required this.placeId,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      description: json['description'],
      distanceMeters: json['distance_meters'],
      placeId: json['place_id'],
    );
  }

  @override
  String toString() {
    return "PredictionModel(description: ${this.description}, distanceMeters: ${this.distanceMeters}, placeId: ${this.placeId})";
  }
}

class SearchResultModel {
  final PlaceDetailsModel placeDetails;
  final String icon;
  final String placeId;

  SearchResultModel({
    @required this.placeDetails,
    @required this.icon,
    @required this.placeId,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      placeDetails: PlaceDetailsModel.fromJson(json['place_id'], json),
      icon: json['icon'],
      placeId: json['place_id'],
    );
  }
}

class PlaceDetailsModel {
  final String placeId;
  final String name;
  final String formattedAddress;
  final double latitude;
  final double longitude;

  PlaceDetailsModel(
    this.placeId, {
    @required this.name,
    @required this.formattedAddress,
    @required this.latitude,
    @required this.longitude,
  });

  factory PlaceDetailsModel.fromJson(String placeId, Map<String, dynamic> json) {
    return PlaceDetailsModel(
      placeId,
      name: json['name'],
      formattedAddress: json['formatted_address'],
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
    );
  }

  Future<RouteModel> findBestRoute(BuildContext context, {int departureTime = 0}) async {
    Position origin = await getCurrentLocationNotNull();

    if (origin == null) {
      LanguageModel language = Provider.of<LanguageModel>(context, listen: false);
      showMyDialog(
        context,
        LocaleText.locationNotAvailable().ofLanguage(language.lang),
        //Constants.Message.LOCATION_NOT_AVAILABLE,
        [DialogButtonModel(text: "OK", value: DialogResult.yes)],
      );
      return Future.value(null);
    }

    List<GateInCostTollModel> routeList = await MyApi.findRoute(
      origin,
      Position(latitude: this.latitude, longitude: this.longitude),
      BlocProvider.of<AppBloc>(context).markerList,
    );

    final GoogleMapsServices googleMapsServices = GoogleMapsServices(context);

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
          LatLng(this.latitude, this.longitude),
          partTollLatLngList,
          departureTime,
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
      destination: this,
      gateInCostToll: bestGateInCostToll,
      departureTime: departureTime,
    );
  }
}
