import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/services/api.dart';

abstract class RouteEvent extends Equatable {
  RouteEvent();

  @override
  List<Object> get props => [];
}

class ListGateIn extends RouteEvent {}

class GateInSelected extends RouteEvent {
  final GateInModel selectedGateIn;

  GateInSelected({@required this.selectedGateIn});
}

class CostTollSelected extends RouteEvent {
  final CostTollModel selectedCostToll;

  CostTollSelected({@required this.selectedCostToll});
}

class DoLocationTracking extends RouteEvent {
  final Position currentLocation;

  DoLocationTracking({@required this.currentLocation});
}

class StopLocationTracking extends RouteEvent {
  StopLocationTracking();
}

class ShowSearchResultRoute extends RouteEvent {
  final RouteModel bestRoute;

  ShowSearchResultRoute({@required this.bestRoute});
}

class UpdateCurrentLocationSearch extends RouteEvent {
  final Position currentLocation;

  UpdateCurrentLocationSearch({@required this.currentLocation});
}
