import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:exattraffic/components/data_loading.dart';
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
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() {
    _presenter.clearIncidentList();
    _presenter.getIncidentList();

    // if failed, use refreshFailed()
    _refreshController.refreshCompleted();
  }

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
      decoration: BoxDecoration(),
      child: _presenter.incidentListModel == null
          ? DataLoading()
          : SmartRefresher(
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: ListView.separated(
                itemCount: _presenter.incidentListModel.data.length,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return IncidentView(
                    incident: IncidentModel(
                      name: '${_presenter.incidentListModel.data[index].title}',
                      description: '${_presenter.incidentListModel.data[index].detail}',
                      date: '${_presenter.incidentListModel.data[index].timeopen}',
                      imageUrl: '${_presenter.incidentListModel.data[index].cover}',
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
            ),
    );
  }
}
