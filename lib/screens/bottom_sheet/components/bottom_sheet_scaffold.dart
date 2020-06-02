import 'dart:async';
import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

import 'tab_strip.dart';

class BottomSheetScaffold extends StatefulWidget {
  BottomSheetScaffold({
    Key key,
    @required this.child,
    @required this.expandPosition,
    @required this.collapsePosition,
    @required this.onChangeSize,
  }) : super(key: key);

  final Widget child;
  final double expandPosition;
  final double collapsePosition;
  final Function onChangeSize;
  final BottomSheetScaffoldState bsss = BottomSheetScaffoldState();

  void toggleSheet() {
    bsss.toggleSheet();
  }

  @override
  BottomSheetScaffoldState createState() => bsss;
}

class BottomSheetScaffoldState extends State<BottomSheetScaffold> with TickerProviderStateMixin {
  AnimationController _controller;
  bool _bottomSheetExpanded = false;

  initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //setState(() {
          _bottomSheetExpanded = true;
        //});
      } else if (status == AnimationStatus.dismissed) {
        //setState(() {
          _bottomSheetExpanded = false;
        //});
      }
      widget.onChangeSize(_bottomSheetExpanded);
    });
    super.initState();
  }

  void toggleSheet() {
    if (_bottomSheetExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    // toggle _bottomSheetExpanded ใน AnimationController's AnimationStatusListener
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          0,
          widget.collapsePosition,
          0,
          0,
        ),
        end: RelativeRect.fromLTRB(
          0,
          widget.expandPosition,
          0,
          0,
        ),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutExpo,
        ),
      ),
      child: ClipRRect(
        //padding: EdgeInsets.all(getPlatformSize(20.0)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(getPlatformSize(13.0)),
          topRight: Radius.circular(getPlatformSize(13.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TabStrip(),
            widget.child,
          ],
        ),
      ),
    );
  }
}
