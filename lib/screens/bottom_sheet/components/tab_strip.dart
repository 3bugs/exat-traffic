import 'dart:async';
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
              color: Color(0xFF665EFF),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Color(0xFF5773FF),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Color(0xFF3497FD),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Color(0xFF3ACCE1),
            ),
          ),
        ],
      ),
    );
  }
}
