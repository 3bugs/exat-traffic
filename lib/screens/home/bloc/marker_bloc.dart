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
      MarkerModel marker = event.marker;

      // แปลง MarkerModel เป็น TollPlazaModel
      yield ShowTollPlazaBottomSheet(
        tollPlaza: TollPlazaModel(
            name: marker.name,
            imageUrl: marker.imagePath,
            cost4Wheels: _getFeeValue(marker.coreConfigList, "4"),
            cost6To10Wheels: _getFeeValue(marker.coreConfigList, "6-10"),
            costOver10Wheels: _getFeeValue(marker.coreConfigList, "over10"),
        ),
      );
    }
  }

  int _getFeeValue(List<CoreConfigModel> coreConfigList, String type) {
    List<CoreConfigModel> list = coreConfigList.where((coreConfig) => coreConfig.code == "4")
        .toList();
    return (list.isNotEmpty && list[0].value != null && list[0].value
        .trim()
        .isNotEmpty) ? int.parse(list[0].value) : -1;
  }
}
