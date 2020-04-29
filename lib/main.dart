import 'package:exattraffic/screens/home/home.dart';
import 'package:exattraffic/screens/login/login.dart';
import 'package:flutter/material.dart';

import 'constants.dart' as Constants;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EXAT Traffic',
      theme: ThemeData(
        primaryColor: Constants.App.PRIMARY_COLOR,
        accentColor: Constants.App.PRIMARY_COLOR,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black.withOpacity(0.0),
        ),
      ),
      home: Home(),
    );
  }
}
