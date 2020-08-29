import 'package:flutter/material.dart';

import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/incident_list_model.dart';
import 'incident.dart';

class IncidentMainPresenter extends BasePresenter<Incident> {
  IncidentListModel incidentListModel;

  IncidentMainPresenter(State<Incident> state) : super(state);

  getIncidentList() async {
    clearError();

    try {
      var res = await ExatApi.fetchIncidentList(state.context);
      setState(() {
        incidentListModel = res;
      });
      clearError();
    } catch (e) {
      setError(1, e.toString());
      print(e);
    }
  }

  clearIncidentList() {
    setState(() {
      incidentListModel = null;
    });
  }
}
