import 'dart:io';
import 'dart:typed_data';

import 'package:exattraffic/etc/map_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/etc/utils.dart';

class CategoryType {
  static const int TOLL_PLAZA = 10;
  static const int CCTV = 11;
  static const int REST_AREA = 12;
  static const int POLICE_STATION = 14;
  static const int U_TURN = 18;
  static const int ENTRANCE = 23;
  static const int EXIT = 24;
  static const int EAST_PASS = 197;
}

class CategoryModel {
  final int id;
  final String name;
  final int code; // category id ที่ไม่เปลี่ยนไปตามภาษา
  final String markerIconUrl;
  final AssetImage markerIconAsset;
  final BitmapDescriptor markerIconBitmap;
  final AssetImage filterOffIconAsset;
  final AssetImage filterOnIconAsset;
  final double filterIconWidth;
  final double filterIconHeight;
  bool selected;

  static Map<int, BitmapDescriptor> categoryIconMap = Map();

  CategoryModel({
    @required this.id,
    @required this.name,
    @required this.code,
    @required this.markerIconUrl,
    @required this.markerIconAsset,
    @required this.markerIconBitmap,
    @required this.filterOffIconAsset,
    @required this.filterOnIconAsset,
    @required this.filterIconWidth,
    @required this.filterIconHeight,
    @required this.selected,
  });

  /*@override
  List<Object> get props => [
        id,
        name,
        markerIconUrl,
        markerIconAsset,
        markerIconBitmap,
        filterOffIconAsset,
        filterOnIconAsset,
        filterIconWidth,
        filterIconHeight,
        selected,
      ];*/

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    AssetImage markerIconAsset, filterOffIconAsset, filterOnIconAsset;
    double filterIconWidth, filterIconHeight;

    switch (json['cate_code']) {
      case CategoryType.TOLL_PLAZA:
        markerIconAsset = AssetImage('assets/images/map_markers/ic_marker_toll_plaza_small.png');
        filterOffIconAsset = AssetImage('assets/images/layers/ic_layer_toll_plaza_off.png');
        filterOnIconAsset = AssetImage('assets/images/layers/ic_layer_toll_plaza_on.png');
        filterIconWidth = getPlatformSize(35.43);
        filterIconHeight = getPlatformSize(35.43);
        break;
      case CategoryType.CCTV:
        markerIconAsset = AssetImage('assets/images/map_markers/ic_marker_cctv_small.png');
        filterOffIconAsset = AssetImage('assets/images/layers/ic_layer_cctv_off.png');
        filterOnIconAsset = AssetImage('assets/images/layers/ic_layer_cctv_on.png');
        filterIconWidth = getPlatformSize(36.23);
        filterIconHeight = getPlatformSize(30.01);
        break;
      case CategoryType.REST_AREA:
        markerIconAsset = AssetImage('assets/images/map_markers/ic_marker_rest_area_small.png');
        filterOffIconAsset = AssetImage('assets/images/layers/ic_layer_rest_area_off.png');
        filterOnIconAsset = AssetImage('assets/images/layers/ic_layer_rest_area_on.png');
        filterIconWidth = getPlatformSize(49.0);
        filterIconHeight = getPlatformSize(49.0);
        break;
      case CategoryType.POLICE_STATION:
        markerIconAsset =
            AssetImage('assets/images/map_markers/ic_marker_police_station_small.png');
        filterOffIconAsset = AssetImage('assets/images/layers/ic_layer_police_station_off.png');
        filterOnIconAsset = AssetImage('assets/images/layers/ic_layer_police_station_on.png');
        filterIconWidth = getPlatformSize(35.32);
        filterIconHeight = getPlatformSize(27.64);
        break;
      case CategoryType.U_TURN:
        markerIconAsset = AssetImage('assets/images/map_markers/ic_marker_uturn_small.png');
        filterOffIconAsset = AssetImage('assets/images/layers/ic_layer_uturn_off.png');
        filterOnIconAsset = AssetImage('assets/images/layers/ic_layer_uturn_on.png');
        filterIconWidth = getPlatformSize(27.91);
        filterIconHeight = getPlatformSize(34.59);
        break;
      case CategoryType.EAST_PASS:
        markerIconAsset = AssetImage('assets/images/map_markers/ic_marker_easy_pass_small.png');
        filterOffIconAsset = AssetImage('assets/images/layers/ic_layer_easy_pass_off.png');
        filterOnIconAsset = AssetImage('assets/images/layers/ic_layer_easy_pass_on.png');
        filterIconWidth = getPlatformSize(42.78);
        filterIconHeight = getPlatformSize(37.91);
        break;
      case CategoryType.ENTRANCE:
        markerIconAsset = AssetImage('assets/images/map_markers/ic_marker_entrance_small.png');
        filterOffIconAsset = AssetImage('assets/images/layers/ic_layer_entrance_off.png');
        filterOnIconAsset = AssetImage('assets/images/layers/ic_layer_entrance_on.png');
        filterIconWidth = getPlatformSize(28.81);
        filterIconHeight = getPlatformSize(38.72);
        break;
      case CategoryType.EXIT:
        markerIconAsset = AssetImage('assets/images/map_markers/ic_marker_exit_small.png');
        filterOffIconAsset = AssetImage('assets/images/layers/ic_layer_exit_off.png');
        filterOnIconAsset = AssetImage('assets/images/layers/ic_layer_exit_on.png');
        filterIconWidth = getPlatformSize(28.81);
        filterIconHeight = getPlatformSize(38.72);
        break;
    }

    return CategoryModel(
      id: json['id'],
      name: json['name'],
      code: json['cate_code'],
      markerIconUrl: Constants.Api.SERVER + json['icon'],
      markerIconAsset: markerIconAsset,
      markerIconBitmap: categoryIconMap[json['cate_code']],
      filterOffIconAsset: filterOffIconAsset,
      filterOnIconAsset: filterOnIconAsset,
      filterIconWidth: filterIconWidth,
      filterIconHeight: filterIconHeight,
      selected: true,
    );
  }

  Future<BitmapDescriptor> getNetworkIcon() async {
    /*final File markerImageFile = await DefaultCacheManager().getSingleFile(this.markerIconUrl);
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    return BitmapDescriptor.fromBytes(markerImageBytes);*/

    return MapHelper.getMarkerImageFromUrl(this.markerIconUrl);
  }

  CategoryModel copyWith({
    int id,
    String name,
    int code,
    String markerIconUrl,
    AssetImage markerIconAsset,
    BitmapDescriptor markerIconBitmap,
    AssetImage filterOffIconAsset,
    AssetImage filterOnIconAsset,
    double filterIconWidth,
    double filterIconHeight,
    bool selected,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      markerIconUrl: markerIconUrl ?? this.markerIconUrl,
      markerIconAsset: markerIconAsset ?? this.markerIconAsset,
      markerIconBitmap: markerIconBitmap ?? this.markerIconBitmap,
      filterOffIconAsset: filterOffIconAsset ?? this.filterOffIconAsset,
      filterOnIconAsset: filterOnIconAsset ?? this.filterOnIconAsset,
      filterIconWidth: filterIconWidth ?? this.filterIconWidth,
      filterIconHeight: filterIconHeight ?? this.filterIconHeight,
      selected: selected ?? this.selected,
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
