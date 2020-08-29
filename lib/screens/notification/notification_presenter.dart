import 'package:flutter/material.dart';

import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/notification_model.dart';
import 'notification.dart';

class NotificationPresenter extends BasePresenter<MyNotification> {
  List<NotificationModel> notificationList;

  NotificationPresenter(State<MyNotification> state) : super(state);

  getNotificationList() async {
    clearError();

    try {
      var res = await ExatApi.fetchNotifications(state.context);
      setState(() {
        notificationList = res;
      });
      clearError();
    } catch (e) {
      setError(1, e.toString());
      print(e);
    }
  }

  clearNotificationList() {
    setState(() {
      notificationList = null;
    });
  }
}
