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
          laneList: _getLaneList(marker.coreConfigList),
        ),
      );
    }
  }

  int _getFeeValue(List<CoreConfigModel> coreConfigList, String type) {
    List<CoreConfigModel> list =
    coreConfigList.where((coreConfig) => coreConfig.code == "4").toList();
    return (list.isNotEmpty && list[0].value != null && list[0].value
        .trim()
        .isNotEmpty)
        ? int.parse(list[0].value)
        : -1;
  }

  List<TollPlazaLaneModel> _getLaneList(List<CoreConfigModel> coreConfigList) {
    List<TollPlazaLaneModel> laneList = List();

    print("******************** LANE ********************");
    coreConfigList
        .where((coreConfig) => coreConfig.code == "markers_channel")
        .forEach((coreConfig) {
      /*final intRegex = RegExp(r'\s+(\d+)\s+', multiLine: true);
      List regexLaneNumberList =
          intRegex.allMatches(coreConfig.name).map((m) => m.group(0)).toList();*/

      TollPlazaLaneType laneType;
      switch (coreConfig.value.toUpperCase()) {
        case "M":
          laneType = TollPlazaLaneType.cash;
          break;
        case "E":
          laneType = TollPlazaLaneType.easyPass;
          break;
      }

      int laneNumber = int.tryParse(coreConfig.name.replaceAll("ช่อง", "")) ?? 0;
      assert(laneNumber > 0);

      if (laneType != null && laneNumber > 0) {
        TollPlazaLaneModel lane = TollPlazaLaneModel(
          number: laneNumber,
          type: laneType,
        );
        laneList.add(lane);
        print(lane);
      }
    });

    return laneList;
  }
}
