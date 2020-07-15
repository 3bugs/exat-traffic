import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';

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

class UpdateCurrentLocation extends RouteEvent {
  final Position currentLocation;

  UpdateCurrentLocation({@required this.currentLocation});
}
