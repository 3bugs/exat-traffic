import 'dart:async';
import 'package:exattraffic/components/data_loading.dart';
import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/incident_model.dart';
import 'package:exattraffic/screens/incident/components/incident_view.dart';

import 'incident_presenter.dart';

class Incident extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IncidentMain();
  }
}

class IncidentMain extends StatefulWidget {
  @override
  _IncidentMainState createState() => _IncidentMainState();
}

class _IncidentMainState extends State<IncidentMain> {

  IncidentMainPresenter _presenter;

//  List<IncidentModel> _incidentList = <IncidentModel>[
//    IncidentModel(
//      name: 'อุบัติเหตุ',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//    IncidentModel(
//      name: 'รถเสีย',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//    IncidentModel(
//      name: 'อุบัติเหตุ',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//    IncidentModel(
//      name: 'รถเสีย',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//    IncidentModel(
//      name: 'อุบัติเหตุ',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//    IncidentModel(
//      name: 'รถเสีย',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//    IncidentModel(
//      name: 'อุบัติเหตุ',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//    IncidentModel(
//      name: 'รถเสีย',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//    IncidentModel(
//      name: 'อุบัติเหตุ',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//    IncidentModel(
//      name: 'รถเสีย',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//    IncidentModel(
//      name: 'อุบัติเหตุ',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//    IncidentModel(
//      name: 'รถเสีย',
//      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
//      date: '22.05.2020',
//      image: AssetImage('assets/images/incident/incident_dummy.png'),
//    ),
//  ];

  @override
  void initState() {
    print('INCIDENT SCREEN');
    _presenter = IncidentMainPresenter(this);
    _presenter.getIncidentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

      ),
      child: _presenter.incidentListModel==null? DataLoading():
      ListView.separated(
        itemCount: _presenter.incidentListModel.data.length,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return IncidentView(
            incident: IncidentModel(
              name: '${_presenter.incidentListModel.data[index].title}',
              description: '${_presenter.incidentListModel.data[index].detail}',
              date: '${_presenter.incidentListModel.data[index].timeopen}',
              image: NetworkImage("${_presenter.incidentListModel.data[index].cover}"),
            ),
            isFirstItem: index == 0,
            isLastItem: index == _presenter.incidentListModel.data.length - 1,
            id: _presenter.incidentListModel.data[index].id,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox.shrink();
        },
      ),
    );
  }
}
