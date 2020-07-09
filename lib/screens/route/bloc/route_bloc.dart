import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';

import 'package:exattraffic/screens/route/bloc/bloc.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/error_model.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(FetchGateInInitial());

  @override
  Stream<RouteState> mapEventToState(RouteEvent event) async* {
    final currentState = state;

    if (event is ListGateIn) {
      try {
        final gateInList = await _fetchGateIn();
        yield FetchGateInSuccess(gateInList: gateInList);
      } catch (_) {
        yield FetchGateInFailure();
      }
    } else if (event is GateInSelected) {
      final GateInModel selectedGateIn = event.selectedGateIn;

      // ถ้าหมุดถูกเลือกอยู่แล้ว ไม่ต้องทำอะไร
      if (currentState.selectedGateIn == selectedGateIn) return;

      currentState.gateInList.forEach((gateIn) {
        gateIn.selected = selectedGateIn == gateIn;
      });

      yield FetchCostTollInitial(
        gateInList: currentState.gateInList,
        costTollList: null,
        selectedGateIn: selectedGateIn,
        selectedCostToll: null,
      );

      try {
        final costTollList = await _fetchCostTollByGateIn(selectedGateIn);
        yield FetchCostTollSuccess(
          gateInList: currentState.gateInList,
          costTollList: costTollList,
          selectedGateIn: selectedGateIn,
        );
      } catch (_) {
        currentState.gateInList.forEach((gateIn) {
          gateIn.selected = false;
        });

        yield FetchCostTollFailure(
          gateInList: currentState.gateInList,
        );
      }
    }
  }
}

// https://bezkoder.com/dart-flutter-parse-json-string-array-to-object-list/
// https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51
Future<List<GateInModel>> _fetchGateIn() async {
  final response = await http.get(Constants.Api.FETCH_GATE_IN_URL);

  if (response.statusCode == 200) {
    Map<String, dynamic> responseBodyJson = json.decode(response.body);
    ErrorModel error = ErrorModel.fromJson(responseBodyJson['error']);

    if (error.code == 0) {
      List dataList = responseBodyJson['data_list'];
      List<GateInModel> gateInList =
          dataList.map((gateInJson) => GateInModel.fromJson(gateInJson)).toList();
      print('Number of Gate In : ${gateInList.length}');

      return gateInList;
    } else {
      print(error.message);
      throw Exception(error.message);
    }
  } else {
    print('เกิดข้อผิดพลาดในการเชื่อมต่อ Server');
    throw Exception('เกิดข้อผิดพลาดในการเชื่อมต่อ Server');
  }
}

Future<List<CostTollModel>> _fetchCostTollByGateIn(GateInModel gateIn) async {
  final response = await http.get('${Constants.Api.FETCH_COST_TOLL_BY_GATE_IN_URL}/${gateIn.id}');

  if (response.statusCode == 200) {
    Map<String, dynamic> responseBodyJson = json.decode(response.body);
    ErrorModel error = ErrorModel.fromJson(responseBodyJson['error']);

    if (error.code == 0) {
      List dataList = responseBodyJson['data_list'];
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

      // pan/zoom map ให้ครอบคลุม bound ของ costToll ทั้งหมด & selectedGateIn
      /*new Future.delayed(Duration(milliseconds: 1000), () async {
        List<LatLng> costTollLatLngList = costTollList
            .map((costToll) => LatLng(costToll.latitude, costToll.longitude))
            .toList();
        costTollLatLngList.add(LatLng(_selectedGateIn.latitude, _selectedGateIn.longitude));
        LatLngBounds latLngBounds = _boundsFromLatLngList(costTollLatLngList);
        final GoogleMapController controller = await _googleMapController.future;
        controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
      });*/
    } else {
      print(error.message);
      throw Exception(error.message);
    }
  } else {
    print('เกิดข้อผิดพลาดในการเชื่อมต่อ Server');
    throw Exception('เกิดข้อผิดพลาดในการเชื่อมต่อ Server');
  }
}
