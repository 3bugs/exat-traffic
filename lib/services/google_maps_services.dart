import 'package:exattraffic/services/api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'AIzaSyC1e9L1eA1YyOhsKW4-BhhwHD2fgtqWnak';
//const apiKey = 'AIzaSyCrBhuovlx9Wk2v7mQNvCg4JIL_affg0ks';

class GoogleMapsServices {
  // https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyC1e9L1eA1YyOhsKW4-BhhwHD2fgtqWnak&language=th&waypoints=via:13.8133553%2C100.55055219999997%7Cvia:13.660109%2C100.66368499999999%7C&origin=13.7998143,100.4187235&destination=13.56686331,100.937025
  Future<Map<String, dynamic>> getRoute(LatLng origin, LatLng destination, List<LatLng> wayPointList) async {
    // &waypoints=via:-37.81223 %2C 144.96254 %7C via:-34.92788 %2C 138.60008

    String wayPoints = wayPointList.fold("", (String previousValue, LatLng wayPoint) {
      return "${previousValue}via:${wayPoint.latitude}%2C${wayPoint.longitude}%7C";
    });

    Map<String, dynamic> params = Map();
    params["waypoints"] = wayPoints;
    params["origin"] = "${origin.latitude},${origin.longitude}";
    params["destination"] = "${destination.latitude},${destination.longitude}";

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
  Future<Map<String, dynamic>> getPlaceAutocomplete(String searchTerm, LatLng latLng) async {
    Map<String, dynamic> params = Map();
    params["input"] = searchTerm;
    params["origin"] = "${latLng.latitude},${latLng.longitude}";

    final ResponseResult result = await _makeRequest("directions", params);
    if (result.success) {
      return result.data["predictions"];
    } else {
      throw Exception(result.data);
    }
  }

  Future<ResponseResult> _makeRequest(String endPoint, Map<String, dynamic> params) async {
    String queryParams = "";
    params.forEach((key, value) {
      queryParams += "&$key=$value";
    });
    final String url = "https://maps.googleapis.com/maps/api/$endPoint/json?key=$apiKey&language=th$queryParams";
    http.Response response = await http.get(url);

    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print("Google Maps API: $url");
    print("Google Maps API Response Status Code: ${response.statusCode}");
    print("Google Maps API Response Body: ${response.body}");
    print("Google Maps API Response Body decode: ${json.decode(response.body)}");
    print("-------------------------------------------------------");

    if (response.statusCode == 200) {
      Map<String, dynamic> dataMap = json.decode(response.body);
      if (dataMap['status'] == 'OK') {
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
