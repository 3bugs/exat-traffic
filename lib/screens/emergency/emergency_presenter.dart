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
  }

  clearEmergencyNumberList() {
    setState(() {
      emergencyNumberList = null;
    });
  }
}
