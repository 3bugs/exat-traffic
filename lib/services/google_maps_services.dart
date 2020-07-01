import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const apiKey = 'AIzaSyC1e9L1eA1YyOhsKW4-BhhwHD2fgtqWnak';
//const apiKey = 'AIzaSyCrBhuovlx9Wk2v7mQNvCg4JIL_affg0ks';

class GoogleMapsServices{
  Future<String> getRouteCoordinates(LatLng origin, LatLng destination)async{
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }
}