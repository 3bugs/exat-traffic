import 'package:exattraffic/storage/cctv_favorite_prefs.dart';
import 'package:exattraffic/storage/place_favorite_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/screens/splash/splash.dart';
import 'package:exattraffic/storage/util_prefs.dart';
import 'package:exattraffic/storage/widget_prefs.dart';
import 'constants.dart' as Constants;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      Phoenix(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => LanguageModel()),
            ChangeNotifierProvider(create: (context) => WidgetPrefs()),
            ChangeNotifierProvider(create: (context) => UtilPrefs()),
            ChangeNotifierProvider(create: (context) => CctvFavoritePrefs()),
            ChangeNotifierProvider(create: (context) => PlaceFavoritePrefs()),
          ],
          child: MyApp(),
        ),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => AppBloc(),
        ),
        /*BlocProvider<FindRouteBloc>(
          create: (context) => FindRouteBloc(),
        ),*/
      ],
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
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
