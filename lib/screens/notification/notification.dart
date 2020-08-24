import 'package:exattraffic/screens/notification/notification_details.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/notification/components/notification_view.dart';
import 'package:exattraffic/screens/notification/notification_presenter.dart';
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/components/no_data.dart';
import 'package:exattraffic/models/notification_model.dart';

class MyNotification extends StatefulWidget {
  @override
  _MyNotificationState createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  NotificationPresenter _presenter;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() {
    _presenter.clearNotificationList();
    _presenter.getNotificationList();

    // if failed, use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _handleClickNotificationItem(NotificationModel notification) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (context, anim1, anim2) => NotificationDetails(notification: notification),
      ),
    );
  }

  @override
  void initState() {
    _presenter = NotificationPresenter(this);
    _presenter.getNotificationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: getPlatformSize(Constants.HomeScreen.SPACE_BEFORE_LIST),
      ),
      color: Constants.App.BACKGROUND_COLOR,
      child: _presenter.notificationList == null
          ? DataLoading()
          : SmartRefresher(
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: _presenter.notificationList.isNotEmpty
                  ? ListView.separated(
                      itemCount: _presenter.notificationList.length,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return NotificationView(
                          onClick: () =>
                              _handleClickNotificationItem(_presenter.notificationList[index]),
                          notification: _presenter.notificationList[index],
                          isFirstItem: index == 0,
                          isLastItem: index == _presenter.notificationList.length - 1,
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
