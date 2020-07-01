import 'package:exattraffic/models/language_model.dart';
//import 'package:exattraffic/screens/login/login.dart';
import 'package:exattraffic/screens/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart' as Constants;

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => LanguageModel(),
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EXAT Traffic',
      theme: ThemeData(
        //fontFamily: 'DBHeavent',
        /*textTheme: TextTheme(
          bodyText1: TextStyle(

          ),
        ),*/
        primaryColor: Constants.App.PRIMARY_COLOR,
        accentColor: Constants.App.PRIMARY_COLOR,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.black.withOpacity(0.0),
        ),
      ),
      home: MyScaffold(),
    );
  }
}
