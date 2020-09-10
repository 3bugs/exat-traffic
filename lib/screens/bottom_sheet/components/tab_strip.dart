import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

class TabStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getPlatformSize(7.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Constants.BottomSheet.TAB_STRIP_COLOR_1,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Constants.BottomSheet.TAB_STRIP_COLOR_2,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Constants.BottomSheet.TAB_STRIP_COLOR_3,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Constants.BottomSheet.TAB_STRIP_COLOR_4,
            ),
          ),
        ],
      ),
    );
  }
}
