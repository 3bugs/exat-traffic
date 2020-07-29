import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

class MyProgressIndicator extends StatelessWidget {
  MyProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getPlatformSize(70.0),
      height: getPlatformSize(70.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1.0),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x44777777),
            blurRadius: getPlatformSize(20.0),
            spreadRadius: getPlatformSize(10.0),
            offset: Offset(
              getPlatformSize(0.0), // move right
              getPlatformSize(0.0), // move down
            ),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: getPlatformSize(5.0),
              ),
              child: Image(
                width: getPlatformSize(50.0),
                height: getPlatformSize(50.0),
                image: AssetImage('assets/images/login/exat_logo_no_text.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            width: getPlatformSize(70.0),
            height: getPlatformSize(70.0),
            child: CircularProgressIndicator(
              strokeWidth: getPlatformSize(3.0),
            ),
          )
        ],
      ),
    );
  }
}
