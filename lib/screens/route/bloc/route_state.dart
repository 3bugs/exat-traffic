import 'package:equatable/equatable.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:flutter/foundation.dart';

abstract class RouteState extends Equatable {
  final List<GateInModel> gateInList;
  final List<CostTollModel> costTollList;
  final GateInModel selectedGateIn;
  final CostTollModel selectedCostToll;
  final Map<String, dynamic> googleRoute;

  const RouteState({
    this.gateInList,
    this.costTollList,
    this.selectedGateIn,
    this.selectedCostToll,
    this.googleRoute,
  });

  @override
  List<Object> get props =>
      [gateInList, costTollList, selectedGateIn, selectedCostToll, googleRoute];
}

class FetchGateInInitial extends RouteState {}

class FetchGateInFailure extends RouteState {}

class FetchGateInSuccess extends RouteState {
  const FetchGateInSuccess({
    @required gateInList,
  }) : super(gateInList: gateInList);
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
