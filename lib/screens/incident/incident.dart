import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/incident_model.dart';
import 'package:exattraffic/screens/incident/components/incident_view.dart';
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/components/no_data.dart';
import 'package:exattraffic/components/error_view.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/locale_text.dart';

import 'incident_presenter.dart';

class Incident extends StatefulWidget {
  @override
  _IncidentState createState() => _IncidentState();
}

class _IncidentState extends State<Incident> {
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
      padding: EdgeInsets.only(
        top: getPlatformSize(Constants.HomeScreen.SPACE_BEFORE_LIST),
      ),
      color: Constants.App.BACKGROUND_COLOR,
      child: _presenter.error != null
          ? Center(
              child: Consumer<LanguageModel>(
                builder: (context, language, child) {
                  return ErrorView(
                    title: LocaleText.error().ofLanguage(language.lang),
                    text: _presenter.error.message,
                    buttonText: LocaleText.tryAgain().ofLanguage(language.lang),
                    withBackground: true,
                    onClick: _presenter.getIncidentList,
                  );
                },
              ),
            )
          : _presenter.incidentListModel == null
              ? DataLoading()
              : SmartRefresher(
                  enablePullDown: true,
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: _presenter.incidentListModel.data.isNotEmpty
                      ? ListView.separated(
                          itemCount: _presenter.incidentListModel.data.length,
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return IncidentView(
                              incident: IncidentModel(
                                name: '${_presenter.incidentListModel.data[index].title}',
                                description: '${_presenter.incidentListModel.data[index].detail}',
                                date: '${_presenter.incidentListModel.data[index].createdAt}',
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
                        )
                      : NoData(),
                ),
    );
  }
}
