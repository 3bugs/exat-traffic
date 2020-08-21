import 'package:flutter/material.dart';

import 'package:exattraffic/models/marker_model.dart';
//import 'package:exattraffic/constants.dart' as Constants;

class GateInModel {
  final int id;
  final String name;
  final int routeId;
  final String routeName;
  final int markerId;
  final int categoryId;
  final double latitude;
  final double longitude;
  final bool enable;
  final int costTollCount;
  bool selected;
  bool notified;
  final MarkerModel marker;

  GateInModel({
    @required this.id,
    @required this.name,
    @required this.routeId,
    @required this.routeName,
    @required this.markerId,
    @required this.categoryId,
    @required this.latitude,
    @required this.longitude,
    @required this.enable,
    @required this.costTollCount,
    @required this.selected,
    @required this.notified,
    @required this.marker,
  });

  factory GateInModel.fromJson(Map<String, dynamic> json, List<MarkerModel> markerList) {
    List<MarkerModel> filteredMarkerList = markerList
        .where((marker) =>
            (marker.latitude == json['lat'] && marker.longitude == json['lng']))
        .toList();

    if (filteredMarkerList.isEmpty) {
      print("GATE IN WITH NO ASSOCIATED MARKER!!! [gate_in_id: ${json['gate_in_id']}, name: ${json['gate_in_name']}, marker_id: ${json['marker_id']}]");
    }
    assert(filteredMarkerList.isNotEmpty);

    return GateInModel(
      id: json['gate_in_id'],
      name: json['gate_in_name'],
      routeId: json['gate_in_route_id'],
      routeName: json['route_name'],
      markerId: json['marker_id'],
      categoryId: json['cate_id'],
      latitude: json['lat'],
      longitude: json['lng'],
      enable: json['enable'] == 1,
      costTollCount: json['cost_tolls_count'],
      selected: false,
      notified: false,
      marker: filteredMarkerList.isNotEmpty ? filteredMarkerList[0] : null,
    );
  }

  @override
  String toString() {
    return '${this.name}';
  }
}

/*
{
  route_name: "ทางพิเศษกาญจนาภิเษก",
  gate_in_route_id: 27,
  gate_in_id: 1,
  gate_in_name: "ด่านบางขุนเทียน",
  marker_id: 288,
  marker_route_id: 27,
  marker_name: "ด่านบางขุนเทียน 1 (ทางเข้า2)",
  cate_id: 10,
  lat: 13.64012615,
  lng: 100.41192817,
  enable: 0,
  cost_tolls_count: 50
},
*/
