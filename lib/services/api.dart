import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/models/error_model.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/marker_model.dart';

// https://bezkoder.com/dart-flutter-parse-json-string-array-to-object-list/
// https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51

class ResponseResult {
  final bool success;
  final dynamic data;

  const ResponseResult({
    @required this.success,
    @required this.data,
  });
}

class MyApi {
  static const String MY_API_BASED_URL = "${Constants.Api.SERVER}/api";
  static const String FETCH_GATE_IN_URL = "$MY_API_BASED_URL/gate_in";
  static const String FETCH_COST_TOLL_BY_GATE_IN_URL = "$MY_API_BASED_URL/cost_toll_by_gate_in";

  static Future<List<GateInModel>> fetchGateIn() async {
    ResponseResult responseResult = await _makeRequest(FETCH_GATE_IN_URL);
    if (responseResult.success) {
      List dataList = responseResult.data;
      List<GateInModel> gateInList =
          dataList.map((gateInJson) => GateInModel.fromJson(gateInJson)).toList();
      print('Number of Gate In : ${gateInList.length}');

      return gateInList;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<List<CostTollModel>> fetchCostTollByGateIn(GateInModel gateIn) async {
    ResponseResult responseResult = await _makeRequest(
      '$FETCH_COST_TOLL_BY_GATE_IN_URL/${gateIn.id}',
    );
    if (responseResult.success) {
      List dataList = responseResult.data;
      List<CostTollModel> costTollList =
          dataList.map((costTollJson) => CostTollModel.fromJson(costTollJson)).toList();

      print('Number of Cost Toll : ${costTollList.length}');
      costTollList.forEach((costToll) {
        print(
            'Cost Toll name: ${costToll.name}, Part Toll count: ${costToll.partTollMarkerList.length}');
        costToll.partTollMarkerList
            .map((partTollMarker) => print('--- ${partTollMarker.name}'))
            .toList();
      });

      return costTollList;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<ResponseResult> _makeRequest(url) async {
    final response = await http.get(url);

    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print("API: $url");
    print("API Response Status Code: ${response.statusCode}");
    print("API Response Body: ${response.body}");
    print("-------------------------------------------------------");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBodyJson = json.decode(response.body);
      ErrorModel error = ErrorModel.fromJson(responseBodyJson['error']);

      if (error.code == 0) {
        List dataList = responseBodyJson['data_list'];
        return ResponseResult(success: true, data: dataList);
      } else {
        print(error.message);
        return ResponseResult(success: false, data: error.message);
      }
    } else {
      String msg = "เกิดข้อผิดพลาดในการเชื่อมต่อ Server";
      print(msg);
      return ResponseResult(success: false, data: msg);
    }
  }
}

class ExatApi {
  static const String EXAT_API_BASED_URL = '${Constants.Api.SERVER}:8081';

  static Future<Map<String, dynamic>> fetchSplash(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/posts/detailByName";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {
        "name": "splashscreen",
      },
    );
    if (responseResult.success) {
      return responseResult.data;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<List<MarkerModel>> fetchMarkers(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/markers/all";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {"limit": "", "sort": "ASC"},
    );
    if (responseResult.success) {
      List dataList = responseResult.data;
      List<MarkerModel> markerList =
          dataList.map((markerJson) => MarkerModel.fromJson(markerJson)).toList();

      return markerList;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<List<CategoryModel>> fetchCategories(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/categories/view";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {"type": "markers"},
    );
    if (responseResult.success) {
      List dataList = responseResult.data;
      List<CategoryModel> categoryList =
          dataList.map((markerJson) => CategoryModel.fromJson(markerJson)).toList();

      return categoryList;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<ResponseResult> _makeRequest(
      BuildContext context, String url, Map<String, dynamic> paramMap) async {
    Position currentLocation = await _getCurrentPosition();

    Map data = {
      "deviceToken": "testToken",
      "deviceType": Platform.isAndroid ? "android" : "ios",
      "screenWidth": MediaQuery.of(context).size.width,
      "screenHeight": MediaQuery.of(context).size.height,
      "lang": "TH",
      "lat": currentLocation != null ? currentLocation.latitude : null,
      "lng": currentLocation != null ? currentLocation.longitude : null,
      "altitude": currentLocation != null ? currentLocation.altitude : null,
      "status": "1",
    };
    data.addAll(paramMap);
    final body = json.encode(data);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer 84a65e5a9f8dac91c9f573aa417a246e",
      },
      body: body,
    );

    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print("API: $url");
    print("API Request Body: $body");
    print("API Response Status Code: ${response.statusCode}");
    print("API Response Body: ${response.body}");
    print("-------------------------------------------------------");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJsonBody = json.decode(response.body);
      if (responseJsonBody['status_code'].toString() == '200') {
        return ResponseResult(success: true, data: responseJsonBody['data']);
      } else {
        print(responseJsonBody['error']);
        return ResponseResult(success: false, data: responseJsonBody['error']);
      }
    } else {
      String msg = "เกิดข้อผิดพลาดในการเชื่อมต่อ Server";
      print(msg);
      return ResponseResult(success: false, data: msg);
    }
  }

  static Future<Position> _getCurrentPosition() async {
    final Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }
}
