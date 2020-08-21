import 'package:flutter/material.dart';

import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/constants.dart' as Constants;

class CostTollModel {
  final int id;
  final String name;
  final int routeId;
  final String routeName;
  final int categoryId;
  final double latitude;
  final double longitude;
  final int cost4Wheels;
  final int cost6To10Wheels;
  final int costOver10Wheels;
  List<MarkerModel> partTollMarkerList;
  bool selected;
  bool notified;
  final MarkerModel marker;

  CostTollModel({
    @required this.id,
    @required this.name,
    @required this.routeId,
    @required this.routeName,
    @required this.categoryId,
    @required this.latitude,
    @required this.longitude,
    @required this.cost4Wheels,
    @required this.cost6To10Wheels,
    @required this.costOver10Wheels,
    @required this.partTollMarkerList,
    @required this.selected,
    @required this.notified,
    @required this.marker,
  });

  factory CostTollModel.fromJson(Map<String, dynamic> json, List<MarkerModel> markerList) {
    List<MarkerModel> partTollMarkerList = json['part_toll_markers']
        .map<MarkerModel>((markerJson) => MarkerModel.fromJson(markerJson))
        .toList();

    List<MarkerModel> newPartTollMarkerList = partTollMarkerList.map((MarkerModel partTollMarker) {
      List<MarkerModel> filteredMarkerList = markerList.where((MarkerModel marker) {
        return (marker.latitude == partTollMarker.latitude) &&
            (marker.longitude == partTollMarker.longitude);
      }).toList();

      if (filteredMarkerList.length == 0) {
        print(
          "MARKER name: ${partTollMarker.name}, categoryId: ${partTollMarker.categoryId}, latitude: ${partTollMarker.latitude}, longitude: ${partTollMarker.longitude}",
        );
      }
      assert(filteredMarkerList.length > 0);
      return filteredMarkerList[0];
    }).toList();

    List<MarkerModel> filteredMarkerList = markerList
        .where((marker) => (marker.latitude == json['lat'] && marker.longitude == json['lng']))
        .toList();

    if (filteredMarkerList.isEmpty) {
      print("COST TOLL WITH NO ASSOCIATED MARKER!!! [id: ${json['id']}, name: ${json['name']}, category_id: ${json['cate_id']}]");
    }
    //assert(filteredMarkerList.isNotEmpty);

    return CostTollModel(
      id: json['id'],
      name: json['name'],
      routeId: json['route_id'],
      routeName: json['route_name'],
      categoryId: json['cate_id'],
      latitude: json['lat'],
      longitude: json['lng'],
      cost4Wheels: json['cost_less4'],
      cost6To10Wheels: json['cost_4to10'],
      costOver10Wheels: json['cost_over10'],
      partTollMarkerList: newPartTollMarkerList,
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
  id: 2480,
  name: "ดินแดง (น.1-03)",
  lat: 13.7657813,
  lng: 100.5487698,
  cate_id: 24,
  part_toll: null,
  cost_less4: 50,
  cost_4to10: 75,
  cost_over10: 110
},
*/
