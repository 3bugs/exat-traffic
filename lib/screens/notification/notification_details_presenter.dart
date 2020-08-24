import 'package:flutter/material.dart';

import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/notification_model.dart';
import 'package:exattraffic/screens/notification/notification_details.dart';
import 'notification_details.dart';

class NotificationDetailsPresenter extends BasePresenter<NotificationDetails> {
  NotificationModel notification;

  NotificationDetailsPresenter(State<NotificationDetails> state) : super(state);

  getNotification(NotificationModel notification) {
    this.notification = notification;
  }
}
