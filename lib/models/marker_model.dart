import 'package:exattraffic/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/marker_categories/cctv_model.dart';
import 'package:exattraffic/models/core_configs_model.dart';
import 'package:exattraffic/screens/marker_details/cctv_details.dart';
import 'package:exattraffic/models/marker_categories/police_station_model.dart';
import 'package:exattraffic/models/marker_categories/rest_area_model.dart';
import 'package:exattraffic/screens/home/bloc/bloc.dart';
import 'package:exattraffic/screens/marker_details/police_station_details.dart';
import 'package:exattraffic/screens/marker_details/rest_area_details.dart';
import 'package:exattraffic/models/marker_categories/uturn_model.dart';
import 'package:exattraffic/screens/marker_details/uturn_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  final int id;
  final String name;
  final int routeId;
  final String routeName;
  final double latitude;
  final double longitude;
  final int categoryId;
  CategoryModel category;
  final String streamMobile;
  final String streamWeb;

  /*final String imageType;
  final String imageSize;*/
  final String imagePath;
  final String godImageUrl;
  final String direction;
  final String phone;
  final int groupId;
  final String groupName;
  final double x;
  final double y;
  final List<CoreConfigModel> coreConfigList;
  bool selected;
  bool notified;

  /*set category(CategoryModel value) {
    _category = value;
  }

  CategoryModel get category => _category;*/

  /*@override
  List<Object> get props => [
        id,
        name,
        routeId,
        routeName,
        latitude,
        longitude,
        categoryId,
        category,
        streamMobile,
        streamWeb,
        imagePath,
        direction,
        selected,
        notified,
      ];*/

  MarkerModel({
    @required this.id,
    @required this.name,
    @required this.routeId,
    @required this.routeName,
    @required this.latitude,
    @required this.longitude,
    @required this.categoryId,
    @required this.streamMobile,
    @required this.streamWeb,
    /*@required this.imageType,
    @required this.imageSize,*/
    @required this.imagePath,
    @required this.godImageUrl,
    @required this.direction,
    @required this.phone,
    @required this.groupId,
    @required this.groupName,
    @required this.x,
    @required this.y,
    @required this.coreConfigList,
    @required this.selected,
    @required this.notified,
  });

  factory MarkerModel.fromJson(Map<String, dynamic> json) {
    var coreConfigJson = json['core_configs'] ?? List();

    // stream_web = ภาพจากระบบอื่นๆ
    // image_path = ภาพจากระบบหลังบ้าน

    final String internalImageUrl = json['image_path'];
    final String externalImageUrl = json['stream_web'];
    String godImageUrl;

    if (internalImageUrl != null && internalImageUrl.trim().length > 7) {
      godImageUrl = internalImageUrl.trim();
    } else if (externalImageUrl != null && externalImageUrl.trim().length > 7) {
      godImageUrl = externalImageUrl.trim();
    }

    if (godImageUrl != null && godImageUrl.substring(0, 4) != "http") {
      godImageUrl = Constants.Api.SERVER + godImageUrl;
    }

    if (godImageUrl != null) {
      int beginIndex = godImageUrl.indexOf("http://", 1);
      if (beginIndex != -1) {
        godImageUrl = godImageUrl.substring(beginIndex);
      }
    }

    String streamMobile = json['stream_mobile'];
    if (streamMobile == null || streamMobile.trim().length <= 7) {
      streamMobile = null;
    }

    double latitude = json['lat'];
    double longitude = json['lng'];
    /*if (latitude > 50 && longitude < 50) {
      double temp = latitude;
      latitude = longitude;
      longitude = temp;
    }*/

    double x, y;
    try {
      // เผื่อส่งมาเป็น int
      x = json['x'].toDouble();
      y = json['y'].toDouble();
    } catch (_) {
      x = null;
      y = null;
    }

    List group = json['group'] ?? List();
    List filteredGroup =
        group.where((item) => item['type'].toString().toLowerCase() == 'cluster').toList();
    int groupId = filteredGroup.isNotEmpty ? filteredGroup[0]['parent'] : 0;
    String groupName = filteredGroup.isNotEmpty ? filteredGroup[0]['group_name'] : '';

    return MarkerModel(
      id: json['id'],
      name: json['name'],
      routeId: json['route_id'],
      routeName: json['route_name'],
      latitude: latitude,
      longitude: longitude,
      categoryId: json['cate_id'],
      streamMobile: streamMobile,
      streamWeb: json['stream_web'],
      imagePath: json['image_path'],
      godImageUrl: godImageUrl,
      direction: json['direction'],
      phone: json['tel'],
      //groupId: json['group_id'],
      groupId: groupId,
      groupName: groupName,
      x: x,
      y: y,
      coreConfigList: coreConfigJson
          .map<CoreConfigModel>((coreConfigJson) => CoreConfigModel.fromJson(coreConfigJson))
          .toList(),
      selected: false,
      notified: false,
    );
  }

  void showDetailsScreen(BuildContext context, {Function callback}) {
    assert(this.category != null);
    if (this.category == null) return;

    String categoryTypeText;

    switch (this.category.code) {
      case CategoryType.CCTV:
        categoryTypeText = 'cctv';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CctvDetails(CctvModel(
              this.id,
              name: this.name,
              streamUrl: this.streamMobile,
              imageUrl: this.godImageUrl,
            )),
          ),
        ).then((_) {
          if (callback != null) {
            callback();
          }
        });
        break;

      case CategoryType.REST_AREA:
        categoryTypeText = 'rest_area';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestAreaDetails(RestAreaModel(
              name: this.name,
              imageUrl: this.godImageUrl,
              hasParkingLot: this
                  .coreConfigList
                  .where((coreConfig) => coreConfig.code == "parking")
                  .toList()
                  .isNotEmpty,
              hasToilet: this
                  .coreConfigList
                  .where((coreConfig) => coreConfig.code == "toilet")
                  .toList()
                  .isNotEmpty,
              hasGasStation: this
                  .coreConfigList
                  .where((coreConfig) => coreConfig.code == "gas_station")
                  .toList()
                  .isNotEmpty,
              hasRestaurant: this
                  .coreConfigList
                  .where((coreConfig) => coreConfig.code == "restaurant")
                  .toList()
                  .isNotEmpty,
              hasCafe: this
                  .coreConfigList
                  .where((coreConfig) => coreConfig.code == "cafe")
                  .toList()
                  .isNotEmpty,
            )),
          ),
        );
        break;

      case CategoryType.POLICE_STATION:
        categoryTypeText = 'police_station';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PoliceStationDetails(PoliceStationModel(
              name: this.name,
              imageUrl: this.godImageUrl,
              phone: this.phone,
            )),
          ),
        );
        break;

      case CategoryType.U_TURN:
        categoryTypeText = 'u_turn';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UTurnDetails(UTurnModel(
              name: this.name,
              imageUrl: this.godImageUrl,
            )),
          ),
        );
        break;

      case CategoryType.TOLL_PLAZA:
        categoryTypeText = 'toll_plaza';

        //context.bloc<HomeBloc>().add(ClickTollPlaza(marker: this));
        BlocProvider.of<MarkerBloc>(context).add(ClickTollPlaza(marker: this));
        break;

      case CategoryType.ENTRANCE:
        categoryTypeText = 'entrance';
        break;

      case CategoryType.EXIT:
        categoryTypeText = 'exit';
        break;

      case CategoryType.EAST_PASS:
        categoryTypeText = 'easy_pass';
        break;
    }

    print('╔═════════════════════════════════════════════');
    print('║ Marker: $categoryTypeText - ${this.name}');
    print('╠═════════════════════════════════════════════');

    MyApi.usageLog(
      context: context,
      pageName: 'ui_map_marker',
      pageKey: categoryTypeText,
      pageData: this.name,
    );
  }

  @override
  String toString() {
    return '${this.name}';
  }

  Map toJson() => {
        'id': this.id,
        'name': this.name,
        'lat': this.latitude,
        'lng': this.longitude,
      };
}

class ClusterModel {
  final int id;
  final String name;
  final List<MarkerModel> markerList = List();

  ClusterModel({@required this.id, @required this.name});

  LatLng getAverageLatLng() {
    /*if (this.markerList.length == 1) {
      return LatLng(this.markerList[0].latitude, this.markerList[0].longitude);
    }*/
    return this.markerList.fold(null, (previousLatLng, marker) {
      double lat, lng;
      if (previousLatLng == null) {
        lat = marker.latitude;
        lng = marker.longitude;
      } else {
        lat = (previousLatLng.latitude + marker.latitude) / 2;
        lng = (previousLatLng.longitude + marker.longitude) / 2;
      }
      return LatLng(lat, lng);
    });
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
