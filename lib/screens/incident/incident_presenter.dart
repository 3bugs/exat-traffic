import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/incident_list_model.dart';
import 'package:flutter/material.dart';
import 'incident.dart';
import '../../services/api.dart';


class IncidentMainPresenter extends BasePresenter<IncidentMain>{
  var ListModel;
  IncidentListModel incidentListModel;

  IncidentMainPresenter(State<IncidentMain> state) : super(state);


  getIncidentList() async {
//    print("getIncidentList");

    try {
      var res = await ExatApi.fetchIncidentList(state.context);
      setState((){
        incidentListModel = res;
      });
      print(incidentListModel.data.length);

    } catch (e) {
      print(e);
    }
  }
}