import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/route_point_model.dart';
import 'package:exattraffic/services/fcm.dart';
import 'package:flutter/material.dart';

import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/emergency_number_model.dart';
import 'emergency.dart';

class EmergencyPresenter extends BasePresenter<Emergency> {
  static List<EmergencyNumberModel> emergencyNumberList;

  EmergencyPresenter(State<Emergency> state) : super(state);

  getEmergencyNumberList() async {
    clearError();

    if (emergencyNumberList == null) {
      try {
        var res = await ExatApi.fetchEmergencyNumbers(state.context);
        setState(() {
          emergencyNumberList = res;
        });
        clearError();
      } catch (e) {
        setError(1, e.toString());
        print(e);
      }
    }

    sortList();
  }

  sortList() {
    if (emergencyNumberList != null) {
      // เอาเบอร์ทั่วไปมาก่อน แล้วค่อยตามด้วยเบอร์ของสายทาง
      emergencyNumberList.sort((a, b) => a.routeId.compareTo(b.routeId));

      // ถ้าอยู่บนสายทางใด ให้เอาเบอร์ของสายทางนั้นมาไว้บนสุด
      final int currentRoute = RoutePointModel.currentRoute;
      //alert(state.context, '', currentRoute.toString());
      if (currentRoute != 0) {
        String ccb;
        switch (currentRoute) {
          case MyFcm.ROUTE_CHALERM:
          case MyFcm.ROUTE_CHALERM_S1:
            ccb = 'CCB1';
            break;
          case MyFcm.ROUTE_SRIRACH:
            ccb = 'CCB2';
            break;
          case MyFcm.ROUTE_CHALONG:
            ccb = 'CCB3';
            break;
          case MyFcm.ROUTE_BURAPA:
            ccb = 'CCB4';
            break;
          case MyFcm.ROUTE_UDORN:
            ccb = 'CCB5';
            break;
          default:
            break;
        }

        if (ccb != null) {
          emergencyNumberList.sort((a, b) {
            //return b.routeId.compareTo(a.routeId);
            if (a.name.toUpperCase().contains(ccb.toUpperCase())) {
              return -1;
            } else if (b.name.toUpperCase().contains(ccb.toUpperCase())) {
              return 1;
            } else {
              return 0;
            }
          });
        }
      }
    }
  }

  clearEmergencyNumberList() {
    setState(() {
      emergencyNumberList = null;
    });
  }
}
