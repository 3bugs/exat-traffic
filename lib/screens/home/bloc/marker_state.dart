import 'package:equatable/equatable.dart';
import 'package:exattraffic/models/marker_categories/toll_plaza_model.dart';
import 'package:flutter/cupertino.dart';

abstract class MarkerState extends Equatable {
  MarkerState();

  @override
  List<Object> get props => [];
}

class ShowTollPlazaBottomSheet extends MarkerState {
  final TollPlazaModel tollPlaza;

  ShowTollPlazaBottomSheet({
    @required this.tollPlaza,
  });

  @override
  List<Object> get props => [tollPlaza];
}
