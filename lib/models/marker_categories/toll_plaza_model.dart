import 'package:exattraffic/models/core_configs_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:flutter/material.dart';

class TollPlazaModel {
  final String name;
  final String imageUrl;
  final int cost4Wheels;
  final int cost6To10Wheels;
  final int costOver10Wheels;
  final List<TollPlazaLaneModel> laneList;

  TollPlazaModel({
    @required this.name,
    @required this.imageUrl,
    @required this.cost4Wheels,
    @required this.cost6To10Wheels,
    @required this.costOver10Wheels,
    @required this.laneList,
  });

  factory TollPlazaModel.fromMarkerModel(MarkerModel marker) {
    return TollPlazaModel(
      name: marker.name,
      imageUrl: marker.imagePath,
      cost4Wheels: _getFeeValue(marker.coreConfigList, "4"),
      cost6To10Wheels: _getFeeValue(marker.coreConfigList, "6-10"),
      costOver10Wheels: _getFeeValue(marker.coreConfigList, "over10"),
      laneList: _getLaneList(marker.coreConfigList),
    );
  }

  static int _getFeeValue(List<CoreConfigModel> coreConfigList, String type) {
    List<CoreConfigModel> list =
    coreConfigList.where((coreConfig) => coreConfig.code == type).toList();
    return (list.isNotEmpty && list[0].value != null && list[0].value.trim().isNotEmpty)
        ? int.parse(list[0].value)
        : -1;
  }

  static List<TollPlazaLaneModel> _getLaneList(List<CoreConfigModel> coreConfigList) {
    List<TollPlazaLaneModel> laneList = List();

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

enum TollPlazaLaneType { cash, easyPass }

class TollPlazaLaneModel {
  final int number;
  final TollPlazaLaneType type;

  TollPlazaLaneModel({
    @required this.number,
    @required this.type,
  });

  @override
  String toString() {
    return "Lane: ${this.number}, Type: ${this.type}";
  }
}
