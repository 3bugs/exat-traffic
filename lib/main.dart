import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/screens/login/login.dart';
import 'package:exattraffic/screens/splash/splash.dart';
import 'package:exattraffic/screens/scaffold.dart';
import 'constants.dart' as Constants;

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => LanguageModel(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => AppBloc(),
        ),
      ],
      child: MaterialApp(
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
        home: Splash(),
      ),
    );
  }
}
