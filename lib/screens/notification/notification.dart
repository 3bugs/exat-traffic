import 'dart:async';
import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/notification_model.dart';
import 'package:exattraffic/screens/notification/components/notification_view.dart';

class MyNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyNotificationMain();
  }
}

class MyNotificationMain extends StatefulWidget {
  @override
  _MyNotificationMainState createState() => _MyNotificationMainState();
}

class _MyNotificationMainState extends State<MyNotificationMain> {
  List<NotificationModel> _notificationList = <NotificationModel>[
    NotificationModel(
      name: 'รายงานสภาพจราจร',
      description: 'ทางพิเศษศรีรัช สภาพคล่องตัว',
      read: false,
    ),
    NotificationModel(
      name: 'รายงานสภาพจราจร',
      description: 'ทางพิเศษศรีรัช สภาพคล่องตัว',
      read: false,
    ),
    NotificationModel(
      name: 'โปรดเตรียมเงินค่าผ่านทาง',
      description: 'กรุณาเตรียมเงินสำหรับค่าผ่านทาง 50 บาท',
      read: false,
    ),
    NotificationModel(
      name: 'โปรดเตรียมเงินค่าผ่านทาง',
      description: 'กรุณาเตรียมเงินสำหรับค่าผ่านทาง 50 บาท',
      read: true,
    ),
    NotificationModel(
      name: 'รายงานสภาพจราจร',
      description: 'ทางพิเศษศรีรัช สภาพคล่องตัว',
      read: true,
    ),
  ];

  @override
  void initState() {
    print('NOTIFICATION SCREEN');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

      ),
      child: ListView.separated(
        itemCount: _notificationList.length,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return NotificationView(
            notification: _notificationList[index],
            isFirstItem: index == 0,
            isLastItem: index == _notificationList.length - 1,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox.shrink();
        },
      ),
    );
  }
}
