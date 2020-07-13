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
      List<MarkerModel> partTollList = currentState.selectedCostToll.partTollMarkerList;
      Position currentLocation = event.currentLocation;

      AlertModel notification;
      for (int i = 0; i < partTollList.length; i++) {
        MarkerModel partToll = partTollList[i];
        double distanceInMeters = await Geolocator().distanceBetween(
          partToll.latitude,
          partToll.longitude,
          currentLocation.latitude,
          currentLocation.longitude,
        );
        if (distanceInMeters < 1000 && !partToll.notified) {
          partToll.notified = true;

          String tollFee =
              "▶ รถ 4 ล้อ:  ${'xxx'} บาท\n▶ รถ 6-10 ล้อ:  ${'xxx'} บาท\n▶ รถเกิน 10 ล้อ:  ${'xxx'} บาท";
          notification = AlertModel(
            title: "เตรียมจ่ายค่าผ่านทาง",
            message:
                "อีก ${(distanceInMeters / 1000).toStringAsFixed(1)} กม. ถึง${partToll.name} กรุณาเตรียมเงินค่าผ่านทาง:\n\n${tollFee}",
          );
          break;
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
}
