import 'package:equatable/equatable.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/models/gate_in_model.dart';

class RouteModel extends Equatable {
  final List<GateInModel> gateInList;
  final List<CostTollModel> costTollList;

  const RouteModel({this.gateInList, this.costTollList});

  @override
  List<Object> get props => [gateInList, costTollList];
}