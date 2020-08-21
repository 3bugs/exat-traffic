import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:equatable/equatable.dart';

import 'package:exattraffic/models/alert_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/services/api.dart';

abstract class RouteState extends Equatable {
  final List<GateInModel> gateInList;
  final List<CostTollModel> costTollList;
  final GateInModel selectedGateIn;
  final CostTollModel selectedCostToll;
  final Map<String, dynamic> googleRoute;
  final Position currentLocation;
  final AlertModel notification;

  const RouteState({
    this.gateInList,
    this.costTollList,
    this.selectedGateIn,
    this.selectedCostToll,
    this.googleRoute,
    this.currentLocation,
    this.notification,
  });

  /*RouteState copyWith({
    List<GateInModel> gateInList,
    List<CostTollModel> costTollList,
    GateInModel selectedGateIn,
    CostTollModel selectedCostToll,
    Map<String, dynamic> googleRoute,
    Position currentLocation,
  }) {
    return RouteState(
      gateInList: gateInList ?? this.gateInList,
      costTollList: costTollList ?? this.costTollList,
      selectedGateIn: selectedGateIn ?? this.selectedGateIn,
      selectedCostToll: selectedCostToll ?? this.selectedCostToll,
      googleRoute: googleRoute ?? this.googleRoute,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }*/

  @override
  List<Object> get props => [
        gateInList,
        costTollList,
        selectedGateIn,
        selectedCostToll,
        googleRoute,
        currentLocation,
        notification
      ];
}

class FetchGateInInitial extends RouteState {}

class FetchGateInFailure extends RouteState {}

class FetchGateInSuccess extends RouteState {
  const FetchGateInSuccess({
    @required gateInList,
  }) : super(
          gateInList: gateInList,
        );
}

class FetchCostTollInitial extends RouteState {
  const FetchCostTollInitial({
    @required gateInList,
    @required selectedGateIn,
  }) : super(
          gateInList: gateInList,
          costTollList: null,
          selectedGateIn: selectedGateIn,
          selectedCostToll: null,
          currentLocation: null,
        );
}

class FetchCostTollFailure extends RouteState {
  const FetchCostTollFailure({
    @required gateInList,
  }) : super(
          gateInList: gateInList,
          costTollList: null,
          selectedGateIn: null,
          selectedCostToll: null,
        );
}

class FetchCostTollSuccess extends RouteState {
  const FetchCostTollSuccess({
    @required gateInList,
    @required costTollList,
    @required selectedGateIn,
  }) : super(
          gateInList: gateInList,
          costTollList: costTollList,
          selectedGateIn: selectedGateIn,
          selectedCostToll: null,
        );
}

class FetchDirectionsInitial extends RouteState {
  const FetchDirectionsInitial({
    @required gateInList,
    @required costTollList,
    @required selectedGateIn,
    @required selectedCostToll,
  }) : super(
          gateInList: gateInList,
          costTollList: costTollList,
          selectedGateIn: selectedGateIn,
          selectedCostToll: selectedCostToll,
          googleRoute: null,
        );
}

class FetchDirectionsFailure extends RouteState {
  const FetchDirectionsFailure({
    @required gateInList,
    @required costTollList,
    @required selectedGateIn,
  }) : super(
          gateInList: gateInList,
          costTollList: costTollList,
          selectedGateIn: selectedGateIn,
          selectedCostToll: null,
          googleRoute: null,
        );
}

class FetchDirectionsSuccess extends RouteState {
  const FetchDirectionsSuccess({
    @required gateInList,
    @required costTollList,
    @required selectedGateIn,
    @required selectedCostToll,
    @required googleRoute,
  }) : super(
          gateInList: gateInList,
          costTollList: costTollList,
          selectedGateIn: selectedGateIn,
          selectedCostToll: selectedCostToll,
          googleRoute: googleRoute,
        );
}

class LocationTrackingUpdated extends RouteState {
  const LocationTrackingUpdated({
    @required gateInList,
    @required costTollList,
    @required selectedGateIn,
    @required selectedCostToll,
    @required googleRoute,
    @required currentLocation,
    @required notification,
  }) : super(
          gateInList: gateInList,
          costTollList: costTollList,
          selectedGateIn: selectedGateIn,
          selectedCostToll: selectedCostToll,
          googleRoute: googleRoute,
          currentLocation: currentLocation,
          notification: notification,
        );
}

class ShowSearchResultRouteState extends RouteState {
  final RouteModel bestRoute;

  ShowSearchResultRouteState({
    @required this.bestRoute,
    @required currentLocation,
    @required notification,
  }) : super(currentLocation: currentLocation, notification: notification);

  @override
  List<Object> get props => [bestRoute];
}

class ShowSearchLocationTrackingUpdated extends ShowSearchResultRouteState {
  //final RouteModel bestRoute;
  //final Position currentLocation;
  //final AlertModel notification;

  ShowSearchLocationTrackingUpdated({
    @required bestRoute,
    @required currentLocation,
    @required notification,
  }) : super(
          bestRoute: bestRoute,
          currentLocation: currentLocation,
          notification: notification,
        );

  @override
  List<Object> get props => [bestRoute, currentLocation];
}
