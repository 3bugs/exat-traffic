import 'dart:async';
import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

class Temp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return wrapSystemUiOverlayStyle(child: TempMain());
    return TempMain();
  }
}

class TempMain extends StatefulWidget {
  @override
  _TempMainState createState() => _TempMainState();
}

class _TempMainState extends State<TempMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.redAccent,
          width: 5.0,
        ),
      ),
    );
  }
}
