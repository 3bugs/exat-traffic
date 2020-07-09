import 'package:equatable/equatable.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:flutter/foundation.dart';

abstract class RouteState extends Equatable {
  final List<GateInModel> gateInList;
  final List<CostTollModel> costTollList;
  final GateInModel selectedGateIn;
  final CostTollModel selectedCostToll;

  const RouteState({
    this.gateInList,
    this.costTollList,
    this.selectedGateIn,
    this.selectedCostToll,
  });

  @override
  List<Object> get props => [gateInList, costTollList, selectedGateIn, selectedCostToll];
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
    @required costTollList,
    @required selectedGateIn,
    @required selectedCostToll,
  }) : super(
          gateInList: gateInList,
          costTollList: costTollList,
          selectedGateIn: selectedGateIn,
          selectedCostToll: selectedCostToll,
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
