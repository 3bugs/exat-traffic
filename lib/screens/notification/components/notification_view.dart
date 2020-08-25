import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/notification_model.dart';
import 'package:exattraffic/components/list_item.dart';

class NotificationView extends StatelessWidget {
  NotificationView({
    @required this.notification,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.onClick,
  });

  final NotificationModel notification;
  final bool isFirstItem;
  final bool isLastItem;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      onClick: onClick,
      marginTop: getPlatformSize(isFirstItem ? 21.0 : 7.0),
      marginBottom: getPlatformSize(isLastItem ? 21.0 : 7.0),
      padding: EdgeInsets.only(
        left: getPlatformSize(16.0),
        right: getPlatformSize(16.0),
        top: getPlatformSize(18.0),
        bottom: getPlatformSize(18.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: getPlatformSize(11.0),
                height: getPlatformSize(11.0),
                decoration: BoxDecoration(
                  color: notification.read ? Color(0xFFA8A8A8) : Color(0xFFB11111),
                  borderRadius: BorderRadius.all(
                    Radius.circular(getPlatformSize(5.5)),
                  ),
                ),
              ),
              SizedBox(
                width: getPlatformSize(10.0),
              ),
              Consumer<LanguageModel>(
                builder: (context, language, child) {
                  String name;
                  switch (language.lang) {
                    case 0:
                      name = notification.detail;
                      break;
                    case 1:
                      name = 'Expressway';
                      break;
                    case 2:
                      name = '高速公路';
                      break;
                  }
                  return Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      language.lang,
                      color: Constants.App.ACCENT_COLOR,
                      isBold: true,
                      heightEn: 1.6,
                    ),
                  );
                },
              ),
            ],
          ),
          Consumer<LanguageModel>(
            builder: (context, language, child) {
              String description;
              switch (language.lang) {
                case 0:
                  description = notification.routeName;
                  break;
                case 1:
                  description = 'Expressway';
                  break;
                case 2:
                  description = '高速公路';
                  break;
              }
              return Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getTextStyle(
                  language.lang,
                  color: Constants.Font.DIM_COLOR,
                  heightEn: 1.6,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
