import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'AIzaSyC1e9L1eA1YyOhsKW4-BhhwHD2fgtqWnak';
//const apiKey = 'AIzaSyCrBhuovlx9Wk2v7mQNvCg4JIL_affg0ks';

class GoogleMapsServices {
  Future<Map<String, dynamic>> getRoute(LatLng origin, LatLng destination, List<LatLng> wayPointList) async {
    // &waypoints=via:-37.81223 %2C 144.96254 %7C via:-34.92788 %2C 138.60008

    String wayPoints = wayPointList.fold("", (String previousValue, LatLng wayPoint) {
      return "${previousValue}via:${wayPoint.latitude}%2C${wayPoint.longitude}%7C";
    });

    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&waypoints=$wayPoints&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    //return values["routes"][0]["overview_polyline"]["points"];
    return values["routes"][0];
  }
}
