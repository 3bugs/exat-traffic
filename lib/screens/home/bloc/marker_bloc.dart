import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:exattraffic/models/core_configs_model.dart';
import 'package:exattraffic/models/marker_categories/toll_plaza_model.dart';
import 'package:exattraffic/models/marker_model.dart';

import 'package:exattraffic/screens/home/bloc/bloc.dart';

class MarkerBloc extends Bloc<MarkerEvent, MarkerState> {
  MarkerBloc() : super(null);

  @override
  Stream<MarkerState> mapEventToState(MarkerEvent event) async* {
    final currentState = state;

    if (event is ClickTollPlaza) {
      // แปลง MarkerModel เป็น TollPlazaModel
      yield ShowTollPlazaBottomSheet(
        tollPlaza: TollPlazaModel.fromMarkerModel(event.marker),
      );
    }
  }
}
