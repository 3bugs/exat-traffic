import 'package:equatable/equatable.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:flutter/cupertino.dart';

abstract class AppState extends Equatable {
  final List<MarkerModel> markerList;

  const AppState({
    this.markerList,
  });

  @override
  List<Object> get props => [markerList];
}

class MarkerInitial extends AppState {}

class MarkerFailure extends AppState {}

class MarkerSuccess extends AppState {
  const MarkerSuccess({
    @required markerList,
  }) : super(
          markerList: markerList,
        );
}
