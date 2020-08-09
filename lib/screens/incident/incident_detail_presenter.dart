import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/incident_detail_model.dart';
import 'package:flutter/material.dart';
import '../../services/api.dart';
import 'incident_detail.dart';

class IncidentDetailPresenter extends BasePresenter<IncidentDetailPage> {
  var ListModel;
  IncidentDetailModel incidentDetailModel;

  IncidentDetailPresenter(State<IncidentDetailPage> state) : super(state);

  getIncidentDetail(int id) async {
//    print("getIncidentDetail");

    try {
      var res = await ExatApi.fetchIncidentDetail(state.context, id);
      setState(() {
        incidentDetailModel = res;
      });
      print(incidentDetailModel.data.title);
    } catch (e) {
      print(e);
    }
  }
}
