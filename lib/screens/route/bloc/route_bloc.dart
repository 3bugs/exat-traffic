import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bloc/bloc.dart';

import 'package:exattraffic/screens/route/bloc/bloc.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/services/google_maps_services.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/models/alert_model.dart';
import 'package:exattraffic/models/marker_model.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(FetchGateInInitial());

  @override
  Stream<RouteState> mapEventToState(RouteEvent event) async* {
    final currentState = state;

    if (event is ListGateIn) {
      try {
        final gateInList = await MyApi.fetchGateIn();
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
        selectedGateIn: selectedGateIn,
      );

      try {
        final costTollList = await MyApi.fetchCostTollByGateIn(selectedGateIn);
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
    } else if (event is CostTollSelected) {
      final CostTollModel selectedCostToll = event.selectedCostToll;

      // ถ้าหมุดถูกเลือกอยู่แล้ว ไม่ต้องทำอะไร
      if (currentState.selectedCostToll == selectedCostToll) return;

      currentState.costTollList.forEach((costToll) {
        costToll.selected = selectedCostToll == costToll;
      });

      yield FetchDirectionsInitial(
        gateInList: currentState.gateInList,
        costTollList: currentState.costTollList,
        selectedGateIn: currentState.selectedGateIn,
        selectedCostToll: selectedCostToll,
      );

      try {
        final GoogleMapsServices googleMapsServices = GoogleMapsServices();

        final List<LatLng> partTollLatLngList = selectedCostToll.partTollMarkerList
            .map((markerModel) => LatLng(markerModel.latitude, markerModel.longitude))
            .toList();

        final route = await googleMapsServices.getRoute(
          LatLng(currentState.selectedGateIn.latitude, currentState.selectedGateIn.longitude),
          LatLng(selectedCostToll.latitude, selectedCostToll.longitude),
          partTollLatLngList,
        );
        yield FetchDirectionsSuccess(
          gateInList: currentState.gateInList,
          costTollList: currentState.costTollList,
          selectedGateIn: currentState.selectedGateIn,
          selectedCostToll: selectedCostToll,
          googleRoute: route,
        );
      } catch (_) {
        yield FetchDirectionsFailure(
          gateInList: currentState.gateInList,
          costTollList: currentState.costTollList,
          selectedGateIn: currentState.selectedGateIn,
        );
      }
    } else if (event is UpdateCurrentLocation) {
      GateInModel selectedGateIn = currentState.selectedGateIn;
      CostTollModel selectedCostToll = currentState.selectedCostToll;
      List<MarkerModel> partTollList = selectedCostToll.partTollMarkerList;
      Position currentLocation = event.currentLocation;

      AlertModel notification;

      if (!selectedGateIn.notified) {
        notification = await _getTollPlazaNotification(
          selectedGateIn.name,
          selectedGateIn.latitude,
          selectedGateIn.longitude,
          currentLocation.latitude,
          currentLocation.longitude,
        );
        selectedGateIn.notified = notification != null;
      }

      if (!selectedCostToll.notified) {
        notification = await _getTollPlazaNotification(
          selectedCostToll.name,
          selectedCostToll.latitude,
          selectedCostToll.longitude,
          currentLocation.latitude,
          currentLocation.longitude,
        );
        selectedCostToll.notified = notification != null;
      }

      for (int i = 0; i < partTollList.length; i++) {
        MarkerModel partToll = partTollList[i];
        if (!partToll.notified) {
          notification = await _getTollPlazaNotification(
            partToll.name,
            partToll.latitude,
            partToll.longitude,
            currentLocation.latitude,
            currentLocation.longitude,
          );
          partToll.notified = notification != null;
        }
      }

      yield LocationTrackingUpdated(
        gateInList: currentState.gateInList,
        costTollList: currentState.costTollList,
        selectedGateIn: currentState.selectedGateIn,
        selectedCostToll: currentState.selectedCostToll,
        googleRoute: currentState.googleRoute,
        currentLocation: event.currentLocation,
        notification: notification,
      );
    }
  }

  Future<AlertModel> _getTollPlazaNotification(String name,
      double lat1,
      double lng1,
      double lat2,
      double lng2,) async {
    const int DISTANCE_THRESHOLD_METER = 1000;
    AlertModel notification;

    double distanceInMeters = await Geolocator().distanceBetween(lat1, lng1, lat2, lng2);
    if (distanceInMeters < DISTANCE_THRESHOLD_METER) {
      String tollFee =
          "▶ รถ 4 ล้อ:  ${'xxx'} บาท\n▶ รถ 6-10 ล้อ:  ${'xxx'} บาท\n▶ รถเกิน 10 ล้อ:  ${'xxx'} บาท";
      notification = AlertModel(
        title: "เตรียมจ่ายค่าผ่านทาง",
        message:
        "อีก ${(distanceInMeters / 1000).toStringAsFixed(
            1)} กม. ถึง$name กรุณาเตรียมเงินค่าผ่านทาง:\n\n$tollFee",
      );
    }
    return notification;
  }
}
