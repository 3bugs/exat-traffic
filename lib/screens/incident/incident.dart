import 'dart:async';
import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/incident_model.dart';
import 'package:exattraffic/screens/incident/components/incident_view.dart';

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
  List<IncidentModel> _incidentList = <IncidentModel>[
    IncidentModel(
      name: 'อุบัติเหตุ',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
    IncidentModel(
      name: 'รถเสีย',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
    IncidentModel(
      name: 'อุบัติเหตุ',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
    IncidentModel(
      name: 'รถเสีย',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
    IncidentModel(
      name: 'อุบัติเหตุ',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
    IncidentModel(
      name: 'รถเสีย',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
    IncidentModel(
      name: 'อุบัติเหตุ',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
    IncidentModel(
      name: 'รถเสีย',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
    IncidentModel(
      name: 'อุบัติเหตุ',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
    IncidentModel(
      name: 'รถเสีย',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
    IncidentModel(
      name: 'อุบัติเหตุ',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
    IncidentModel(
      name: 'รถเสีย',
      description: 'ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ทดสอบ ',
      date: '22.05.2020',
      image: AssetImage('assets/images/incident/incident_dummy.png'),
    ),
  ];

  @override
  void initState() {
    print('INCIDENT SCREEN');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

      ),
      child: ListView.separated(
        itemCount: _incidentList.length,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return IncidentView(
            incident: _incidentList[index],
            isFirstItem: index == 0,
            isLastItem: index == _incidentList.length - 1,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox.shrink();
        },
      ),
    );
  }
}
