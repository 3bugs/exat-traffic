import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/models/error_model.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/marker_model.dart';

//import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/FAQ_model.dart';
import 'package:exattraffic/models/about_model.dart';
import 'package:exattraffic/models/add_answers_model.dart';
import 'package:exattraffic/models/consent_model.dart';
import 'package:exattraffic/models/express_way_model.dart';
import 'package:exattraffic/models/help_model.dart';
import 'package:exattraffic/models/incident_detail_model.dart';
import 'package:exattraffic/models/incident_list_model.dart';
import 'package:exattraffic/models/questionnair_model.dart';
import 'package:exattraffic/models/notification_model.dart';
import 'package:exattraffic/services/google_maps_services.dart';
import 'package:exattraffic/models/emergency_number_model.dart';
import 'package:exattraffic/models/language_model.dart';

// https://bezkoder.com/dart-flutter-parse-json-string-array-to-object-list/
// https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51

Future<Position> _getCurrentLocationForApi() async {
  Position position = await Geolocator().getLastKnownPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  return position;
}

class ResponseResult {
  final bool success;
  final dynamic data;
  final dynamic decode;

  const ResponseResult({
    @required this.success,
    @required this.data,
    this.decode,
  });
}

class MyApi {
  static String MY_API_BASED_URL = "${Constants.Api.SERVER}/api";
  static String FETCH_TRAFFIC_DATA_URL = "$MY_API_BASED_URL/route_traffic";
  static String FETCH_GATE_IN_URL = "$MY_API_BASED_URL/gate_in";
  static String FETCH_COST_TOLL_BY_GATE_IN_URL = "$MY_API_BASED_URL/cost_toll_by_gate_in";
  static String FIND_BEST_ROUTE_URL = "$MY_API_BASED_URL/best_route";

  static Future<String> fetchServerIp() async {
    ResponseResult responseResult = await _makeRequest("http://163.47.9.26/server_ip");
    if (responseResult.success) {
      List dataList = responseResult.data;
      String ip = dataList[0]['ip'];
      print('Server IP: $ip');
      return ip;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<List<TrafficPointDataModel>> fetchTrafficData() async {
    ResponseResult responseResult = await _makeRequest(FETCH_TRAFFIC_DATA_URL);
    if (responseResult.success) {
      List dataList = responseResult.data;
      List<TrafficPointDataModel> trafficPointList = dataList
          .map((trafficPointJson) => TrafficPointDataModel.fromJson(trafficPointJson))
          .toList();
      print('Number of Traffic Point Data : ${trafficPointList.length}');

      return trafficPointList;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<List<GateInModel>> fetchGateIn(
    List<MarkerModel> markerList,
    String langCode,
  ) async {
    ResponseResult responseResult = await _makeRequest('$FETCH_GATE_IN_URL?language=$langCode');
    if (responseResult.success) {
      List dataList = responseResult.data;
      List<GateInModel> gateInList =
          dataList.map((gateInJson) => GateInModel.fromJson(gateInJson, markerList)).toList();
      print('Number of Gate In : ${gateInList.length}');

      return gateInList;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<List<CostTollModel>> fetchCostTollByGateIn(
    GateInModel gateIn,
    List<MarkerModel> markerList,
    String langCode,
  ) async {
    ResponseResult responseResult = await _makeRequest(
      '$FETCH_COST_TOLL_BY_GATE_IN_URL/${gateIn.id}?language=$langCode',
    );
    if (responseResult.success) {
      List dataList = responseResult.data;
      List<CostTollModel> costTollList =
          dataList.map((costTollJson) => CostTollModel.fromJson(costTollJson, markerList)).toList();

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

  static Future<List<GateInCostTollModel>> findRoute(
    Position origin,
    Position destination,
    List<MarkerModel> markerList,
  ) async {
    ResponseResult responseResult = await _makeRequest(
      '$FIND_BEST_ROUTE_URL?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}',
    );
    if (responseResult.success) {
      List dataList = responseResult.data;
      List<GateInCostTollModel> gateInCostTollList = dataList
          .map((gateInCostTollJson) => GateInCostTollModel.fromJson(gateInCostTollJson, markerList))
          .toList();
      return gateInCostTollList;

      /*gateInCostTollList.forEach((gateInCostToll) {
        print("******************** GateInCostToll ********************");
        print(gateInCostToll);
      });*/
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

class GateInCostTollModel {
  final GateInModel gateIn;
  final CostTollModel costToll;
  Map<String, dynamic> googleRoute;

  GateInCostTollModel({@required this.gateIn, @required this.costToll});

  factory GateInCostTollModel.fromJson(Map<String, dynamic> json, List<MarkerModel> markerList) {
    return GateInCostTollModel(
      gateIn: GateInModel.fromJson(json['gate_in'], markerList),
      costToll: CostTollModel.fromJson(json['cost_toll'], markerList),
    );
  }

  @override
  String toString() {
    return "++++++++++++++++++++\n[Gate In] - " +
        "name: ${gateIn.name}, latitude: ${gateIn.latitude}, longitude: ${gateIn.longitude}\n" +
        "[Cost Toll] - " +
        "name: ${costToll.name}, latitude: ${costToll.latitude}, longitude: ${costToll.longitude}\n" +
        "[directions] - ${googleRoute.toString()}\n--------------------\n\n";
  }
}

class RouteModel {
  final PlaceDetailsModel origin;
  final PlaceDetailsModel destination;
  final List<GateInCostTollModel> gateInCostTollList = List();
  final int departureTime;

  RouteModel({
    @required this.origin,
    @required this.destination,
    @required GateInCostTollModel gateInCostToll,
    @required this.departureTime,
  }) {
    this.gateInCostTollList.add(gateInCostToll);
  }
}

class ExatApi {
  static String EXAT_API_BASED_URL = '${Constants.Api.SERVER}:8089';

  static List<ExpressWayModel> _expressWayList;

  static void clearCache() {
    _expressWayList = null;
  }

  static Future<List> fetchSplash(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/posts/detailByName";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {
        "name": "splashscreen",
      },
    );
    if (responseResult.success) {
      if (responseResult.data is List) {
        return responseResult.data;
      } else {
        return new List()..add(responseResult.data);
      }
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<List<ExpressWayModel>> fetchExpressWays(
    BuildContext context,
    List<MarkerModel> markerList, // เอามา map point id กับ cctv
  ) async {
    if (_expressWayList != null) {
      return Future.value(_expressWayList);
    }

    final String url = "$EXAT_API_BASED_URL/routes/list";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {},
    );
    if (responseResult.success) {
      List dataList = responseResult.data ?? List();
      //return dataList.map((expressWayJson) => ExpressWayModel.fromJson(expressWayJson)).toList();
      List<ExpressWayModel> expressWayList = dataList
          .asMap()
          .entries
          .map((entry) => ExpressWayModel.fromJson(entry.value, entry.key, markerList))
          .toList();
      _expressWayList = expressWayList;
      return expressWayList;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<List<EmergencyNumberModel>> fetchEmergencyNumbers(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/departments/list";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {"cat_emer_id": "*"},
    );
    if (responseResult.success) {
      List dataList = responseResult.data ?? List();
      List<EmergencyNumberModel> emergencyNumberList =
          dataList.map((markerJson) => EmergencyNumberModel.fromJson(markerJson)).toList();

      return emergencyNumberList;
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
      List dataList = responseResult.data ?? List();
      List<MarkerModel> markerList =
          dataList.map((markerJson) => MarkerModel.fromJson(markerJson)).toList();

      print('***** MARKER COUNT: ${markerList.length}');
      /*markerList.forEach((marker) {
        print(
            "***** MARKER [${marker.name}] - lat: ${marker.latitude}, lng: ${marker.longitude}, category id: ${marker.categoryId}, image path: ${marker.imagePath}");
      });*/

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
      List dataList = responseResult.data ?? List();

      // filter ให้เหลือเฉพาะ category ที่ใช้งาน (status = 1)
      //List filteredDataList = dataList.where((markerJson) => markerJson['status'] == 1).toList();

      List<CategoryModel> categoryList =
          dataList.map((markerJson) => CategoryModel.fromJson(markerJson)).toList();

      print('***** CATEGORY COUNT: ${categoryList.length}');
      /*categoryList.forEach((category) {
        print(
            "***** CATEGORY [${category.name}] - category id: ${category.id}, category code: ${category.code}");
      });*/

      return categoryList;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<MarkerModel> fetchMarkerDetails(BuildContext context, int id) async {
    final String url = "$EXAT_API_BASED_URL/markers/view";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {"id": id},
    );
    if (responseResult.success) {
      Map<String, dynamic> markerJson = responseResult.data;
      return MarkerModel.fromJson(markerJson);
    } else {
      throw Exception(responseResult.data);
    }
  }

  static List<int> _timePeriodList;

  static Future<List<int>> fetchTimePeriod(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/coreconfigs/view";

    if (_timePeriodList != null) {
      return _timePeriodList;
    }

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {"requestData": "time_period", "filterBy": "group", "fields": "*"},
    );
    if (responseResult.success) {
      List dataList = responseResult.data ?? List();
      _timePeriodList = [0];
      _timePeriodList.addAll(dataList.map<int>((period) => int.parse(period['value'])).toList());
      return _timePeriodList;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<QuestionnaireModel> fetchQuestions(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/questions/view";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {"mode": "1"},
    );
    if (responseResult.success) {
      QuestionnaireModel _model = QuestionnaireModel.fromJson(responseResult.decode);

      return _model;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<AddAnswersModel> addAnswers(BuildContext context, String id, String score) async {
    final String url = "$EXAT_API_BASED_URL/answers/add";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {"quest_id": id, "score": score, "detail": "xxx", "token": "testToken device answer"},
    );
    if (responseResult.success) {
      AddAnswersModel _model = AddAnswersModel.fromJson(responseResult.decode);

      return _model;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<FAQModel> fetchFAQ(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/questions/faq";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {},
    );
    if (responseResult.success) {
      FAQModel _model = FAQModel.fromJson(responseResult.decode);

      return _model;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<AboutModel> fetchAbout(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/posts/detailByName";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {
        "name": "aboutus",
      },
    );
    if (responseResult.success) {
      AboutModel _model = AboutModel.fromJson(responseResult.decode);

      return _model;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<HelpModel> fetchHelp(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/posts/detailByName";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {
        "name": "help",
      },
    );
    if (responseResult.success) {
      HelpModel _model = HelpModel.fromJson(responseResult.decode);

      return _model;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<IncidentListModel> fetchIncidentList(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/messages/list";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {"altitude": null, "status": "1", "limit": 10},
    );
    if (responseResult.success) {
      IncidentListModel _model = IncidentListModel.fromJson(responseResult.decode);

      return _model;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<IncidentDetailModel> fetchIncidentDetail(BuildContext context, int id) async {
    final String url = "$EXAT_API_BASED_URL/messages/view";

    print("id = $id");

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {"altitude": null, "status": "1", "id": id},
    );
    if (responseResult.success) {
      IncidentDetailModel _model = IncidentDetailModel.fromJson(responseResult.decode);

      return _model;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<ConsentModel> fetchConsent(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/posts/detailByName";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {
        "name": "termsandconditions",
      },
      sendLocation: false,
    );
    if (responseResult.success) {
      ConsentModel _model = ConsentModel.fromJson(responseResult.decode);

      return _model;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static Future<List<NotificationModel>> fetchNotifications(BuildContext context) async {
    final String url = "$EXAT_API_BASED_URL/message-event/list";

    ResponseResult responseResult = await _makeRequest(
      context,
      url,
      {"limit": 100},
    );
    if (responseResult.success) {
      List dataList = responseResult.data ?? List();
      List<NotificationModel> notificationList = await Future.wait(dataList
          .map((markerJson) async => await NotificationModel.fromJson(markerJson))
          .toList());

      return notificationList;
    } else {
      throw Exception(responseResult.data);
    }
  }

  static bool _userDenyLocation = false;

  static Future<ResponseResult> _makeRequest(
    BuildContext context,
    String url,
    Map<String, dynamic> paramMap, {
    bool sendLocation = true,
  }) async {
    Position currentLocation;
    if (!_userDenyLocation) {
      try {
        currentLocation = sendLocation ? await _getCurrentLocationForApi() : null;
      } catch (e) {
        print(e);
        _userDenyLocation = true;
      }
    }

    Map data = {
      "deviceToken": await FirebaseMessaging().getToken(),
      "deviceType": Platform.isAndroid ? "android" : "ios",
      "screenWidth": MediaQuery.of(context).size.width,
      "screenHeight": MediaQuery.of(context).size.height,
      "lang": Provider.of<LanguageModel>(context, listen: false).langCode,
      "lat": currentLocation != null ? currentLocation.latitude : null,
      "lng": currentLocation != null ? currentLocation.longitude : null,
      "altitude": currentLocation != null ? currentLocation.altitude : null,
      "status": "1",
    };
    data.addAll(paramMap);
    final body = json.encode(data);

    int beginTime = DateTime.now().millisecondsSinceEpoch;
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer 84a65e5a9f8dac91c9f573aa417a246e",
      },
      body: body,
    );
    int endTime = DateTime.now().millisecondsSinceEpoch;

    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print("Duration: ${((endTime - beginTime) / 1000).toStringAsFixed(1)} วินาที");
    print("API: $url");
    print("API Request Body: $body");
    print("API Response Status Code: ${response.statusCode}");
    print("API Response Body: ${response.body}");
    //print("API Response Body decode: ${json.decode(response.body)}");
    print("-------------------------------------------------------");

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> responseJsonBody = json.decode(response.body);

        bool isApiValid =
            responseJsonBody.containsKey('status_code') && responseJsonBody.containsKey('data');
        //assert(isApiValid);
        if (!isApiValid) {
          String msg = "เกิดข้อผิดพลาดในการเชื่อมต่อ Server: Invalid API Response";
          print(msg);
          return ResponseResult(success: false, data: msg);
        }

        if (responseJsonBody['status_code'].toString() == '200') {
          return ResponseResult(
              success: true, data: responseJsonBody['data'], decode: responseJsonBody);
        } else {
          print(responseJsonBody['error']);
          return ResponseResult(success: false, data: responseJsonBody['error']);
        }
      } catch (error) {
        String msg = "เกิดข้อผิดพลาดในการเชื่อมต่อ Server: $error";
        print(msg);
        return ResponseResult(success: false, data: msg);
      }
    } else {
      String msg = "เกิดข้อผิดพลาดในการเชื่อมต่อ Server";
      print(msg);
      return ResponseResult(success: false, data: msg);
    }
  }
}
