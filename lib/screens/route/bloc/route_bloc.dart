import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

import 'package:exattraffic/screens/route/bloc/bloc.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/services/google_maps_services.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/models/alert_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/locale_text.dart';
import 'package:exattraffic/models/marker_categories/toll_plaza_model.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final BuildContext _context;
  final List<MarkerModel> markerList;
  final List<CategoryModel> categoryList;
  List<GateInModel> _gateInList;
  RouteModel _bestRoute;

  RouteBloc(
    this._context, {
    @required this.markerList,
    @required this.categoryList,
  }) : super(FetchGateInInitial());

  RouteModel get bestRoute => _bestRoute;

  @override
  Stream<RouteState> mapEventToState(RouteEvent event) async* {
    final currentState = state;

    if (event is ShowSearchResultRoute) {
      // ให้ clear marker และ pause location tracking
      //yield FetchGateInSuccess(gateInList: List<GateInModel>());

      _bestRoute = event.bestRoute;

      yield ShowSearchResultRouteState(
        bestRoute: event.bestRoute,
        currentLocation: null,
        notification: null,
      );
    } else if (event is UpdateCurrentLocationSearch) {
      print("***** UPDATE CURRENT LOCATION [SEARCH] *****");

      AlertModel notification;
      GateInCostTollModel gateInCostToll = _bestRoute.gateInCostTollList[0];

      if (gateInCostToll.gateIn.marker.category.code == CategoryType.TOLL_PLAZA &&
          !gateInCostToll.gateIn.notified) {
        notification = await _getTollPlazaNotification(
          gateInCostToll.gateIn.marker,
          event.currentLocation,
        );
        gateInCostToll.gateIn.notified = notification != null;
      }

      if (gateInCostToll.costToll.marker != null &&
          gateInCostToll.costToll.marker.category.code == CategoryType.TOLL_PLAZA &&
          !gateInCostToll.costToll.notified) {
        notification = await _getTollPlazaNotification(
          gateInCostToll.costToll.marker,
          event.currentLocation,
        );
        gateInCostToll.costToll.notified = notification != null;
      }

      for (int i = 0; i < gateInCostToll.costToll.partTollMarkerList.length; i++) {
        MarkerModel partToll = gateInCostToll.costToll.partTollMarkerList[i];
        if (partToll.category.code == CategoryType.TOLL_PLAZA && !partToll.notified) {
          notification = await _getTollPlazaNotification(
            partToll,
            event.currentLocation,
          );
          partToll.notified = notification != null;
        }
      }

      yield ShowSearchLocationTrackingUpdated(
        bestRoute: _bestRoute,
        currentLocation: event.currentLocation,
        notification: notification,
      );
    }

    if (event is ListGateIn) {
      yield FetchGateInInitial();

      try {
        if (_gateInList == null) {
          _gateInList = await MyApi.fetchGateIn(this.markerList);
        } else {
          _gateInList.forEach((gateIn) => gateIn.selected = false);
        }
        yield FetchGateInSuccess(gateInList: _gateInList);
      } catch (error) {
        yield FetchGateInFailure(errorMessage: error.toString());
      }
    } else if (event is GateInSelected) {
      final GateInModel selectedGateIn = event.selectedGateIn;

      // ถ้าหมุดถูกเลือกอยู่แล้ว ไม่ต้องทำอะไร
      if (currentState.selectedGateIn == selectedGateIn && !(currentState is FetchCostTollFailure))
        return;

      currentState.gateInList.forEach((gateIn) {
        gateIn.selected = selectedGateIn == gateIn;
      });

      yield FetchCostTollInitial(
        gateInList: currentState.gateInList,
        selectedGateIn: selectedGateIn,
      );

      try {
        final costTollList = await MyApi.fetchCostTollByGateIn(selectedGateIn, this.markerList);

        // replace part toll marker ด้วย marker ที่โหลดมาตอนเข้าแอพ
        /*costTollList.forEach((CostTollModel costTollModel) {
          assert(this.markerList != null);
          assert(costTollModel.partTollMarkerList != null);

          List<MarkerModel> newPartTollMarkerList =
              costTollModel.partTollMarkerList.map((MarkerModel partTollMarker) {
            List<MarkerModel> filteredMarkerList = this.markerList.where((MarkerModel marker) {
              return (marker.latitude == partTollMarker.latitude) &&
                  (marker.longitude == partTollMarker.longitude);
            }).toList();

            if (filteredMarkerList.length == 0) {
              print(
                  "MARKER name: ${partTollMarker.name}, categoryId: ${partTollMarker.categoryId}, latitude: ${partTollMarker.latitude}, longitude: ${partTollMarker.longitude}"
              );
            }
            assert(filteredMarkerList.length > 0);
            return filteredMarkerList[0];
          }).toList();

          costTollModel.partTollMarkerList = newPartTollMarkerList;
        });*/

        yield FetchCostTollSuccess(
          gateInList: currentState.gateInList,
          costTollList: costTollList,
          selectedGateIn: selectedGateIn,
        );
      } catch (error) {
        print(error);

        currentState.gateInList.forEach((gateIn) {
          gateIn.selected = false;
        });

        yield FetchCostTollFailure(
          gateInList: currentState.gateInList,
          selectedGateIn: selectedGateIn,
          errorMessage: error.toString(),
        );
      }
    } else if (event is CostTollSelected) {
      final CostTollModel selectedCostToll = event.selectedCostToll;

      // ถ้าหมุดถูกเลือกอยู่แล้ว ไม่ต้องทำอะไร
      if (currentState.selectedCostToll == selectedCostToll &&
          !(currentState is FetchDirectionsFailure)) return;

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
        final GoogleMapsServices googleMapsServices = GoogleMapsServices(_context);

        final List<LatLng> partTollLatLngList = selectedCostToll.partTollMarkerList
            .map((markerModel) => LatLng(markerModel.latitude, markerModel.longitude))
            .toList();

        var googleRoute = await googleMapsServices.getRoute(
            LatLng(currentState.selectedGateIn.latitude, currentState.selectedGateIn.longitude),
            LatLng(selectedCostToll.latitude, selectedCostToll.longitude),
            partTollLatLngList,
            0);

        yield FetchDirectionsSuccess(
          gateInList: currentState.gateInList,
          costTollList: currentState.costTollList,
          selectedGateIn: currentState.selectedGateIn,
          selectedCostToll: selectedCostToll,
          googleRoute: googleRoute,
        );
      } catch (error) {
        yield FetchDirectionsFailure(
          gateInList: currentState.gateInList,
          costTollList: currentState.costTollList,
          selectedGateIn: currentState.selectedGateIn,
          selectedCostToll: selectedCostToll,
          errorMessage: error.toString(),
        );
      }
    } else if (event is StopLocationTracking) {
      yield FetchDirectionsSuccess(
        gateInList: currentState.gateInList,
        costTollList: currentState.costTollList,
        selectedGateIn: currentState.selectedGateIn,
        selectedCostToll: currentState.selectedCostToll,
        googleRoute: currentState.googleRoute,
      );
    } else if (event is DoLocationTracking) {
      print("***** UPDATE CURRENT LOCATION [GATEIN/COSTTOLL] *****");

      try {
        // todo: (bug) selectedCostToll = null ?!?
        GateInModel selectedGateIn = currentState.selectedGateIn;
        CostTollModel selectedCostToll = currentState.selectedCostToll;
        List<MarkerModel> partTollList = selectedCostToll.partTollMarkerList;
        Position currentLocation = event.currentLocation;

        AlertModel notification;

        if (selectedGateIn.marker.category.code == CategoryType.TOLL_PLAZA &&
            !selectedGateIn.notified) {
          notification = await _getTollPlazaNotification(
            selectedGateIn.marker,
            currentLocation,
          );
          selectedGateIn.notified = notification != null;
        }

        if (selectedCostToll.marker != null &&
            selectedCostToll.marker.category.code == CategoryType.TOLL_PLAZA &&
            !selectedCostToll.notified) {
          notification = await _getTollPlazaNotification(selectedCostToll.marker, currentLocation);
          selectedCostToll.notified = notification != null;
        }

        for (int i = 0; i < partTollList.length; i++) {
          MarkerModel partToll = partTollList[i];
          if (partToll.category.code == CategoryType.TOLL_PLAZA && !partToll.notified) {
            notification = await _getTollPlazaNotification(
              partToll,
              currentLocation,
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
      } catch (_) {}
    }
  }

  Future<AlertModel> _getTollPlazaNotification(
    MarkerModel marker,
    Position currentLocation,
  ) async {
    const int DISTANCE_THRESHOLD_METER = 1000;
    AlertModel notification;

    double distanceInMeters = await Geolocator().distanceBetween(
      marker.latitude,
      marker.longitude,
      currentLocation.latitude,
      currentLocation.longitude,
    );
    if (distanceInMeters < DISTANCE_THRESHOLD_METER) {
      LanguageModel language = Provider.of<LanguageModel>(_context, listen: false);

      TollPlazaModel tollPlaza = TollPlazaModel.fromMarkerModel(marker);

      String fourWheels = LocaleText.fourWheels().ofLanguage(language.lang);
      String sixToTenWheels = LocaleText.sixToTenWheels().ofLanguage(language.lang);
      String overTenWheels = LocaleText.overTenWheels().ofLanguage(language.lang);
      String amountBaht = LocaleText.amountBaht().ofLanguage(language.lang);
      String tollFee = sprintf(
        "- $fourWheels:  $amountBaht\n- $sixToTenWheels:  $amountBaht\n- $overTenWheels:  $amountBaht",
        [tollPlaza.cost4Wheels, tollPlaza.cost6To10Wheels, tollPlaza.costOver10Wheels],
      );
      notification = AlertModel(
        title: "เตรียมจ่ายค่าผ่านทาง",
        message: sprintf(
          LocaleText.payTollAhead().ofLanguage(language.lang) + '\n\n$tollFee',
          [(distanceInMeters / 1000).toStringAsFixed(1), marker.name],
        ),
        //"อีก ${(distanceInMeters / 1000).toStringAsFixed(1)} กม. ถึง${marker.name} กรุณาเตรียมเงินค่าผ่านทาง:\n\n$tollFee",
      );
    }
    return notification;
  }
}
