import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/screens/splash/splash.dart';
import 'package:exattraffic/storage/util_prefs.dart';
import 'package:exattraffic/storage/widget_prefs.dart';
import 'package:exattraffic/storage/cctv_favorite_prefs.dart';
import 'package:exattraffic/storage/place_favorite_prefs.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/services/fcm.dart';

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

    //https://pub.dev/documentation/flutter_background_geolocation/latest/flt_background_geolocation/BackgroundGeolocation/registerHeadlessTask.html
    // Register your headlessTask:
    bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
  });
}

DateTime lastTracking;

void trackUser(bg.Location location) {
  if (lastTracking == null || DateTime.now().difference(lastTracking).inSeconds > 300) {
    MyFcm.getToken().then((token) {
      try {
        MyApi.trackUser(token, location.coords.latitude, location.coords.longitude);
      } catch (e) {}
    });
  }
}

void headlessTask(bg.HeadlessEvent headlessEvent) async {
  print('[BackgroundGeolocation HeadlessTask]: $headlessEvent');
  // Implement a 'case' for only those events you're interested in.
  switch (headlessEvent.name) {
    case bg.Event.TERMINATE:
      bg.State state = headlessEvent.event;
      print('- State: $state');
      break;
    case bg.Event.HEARTBEAT:
      bg.HeartbeatEvent event = headlessEvent.event;
      print('- HeartbeatEvent: $event');
      break;
    case bg.Event.LOCATION:
      bg.Location location = headlessEvent.event;
      trackUser(location);
      print('- Location: $location');
      break;
    case bg.Event.MOTIONCHANGE:
      bg.Location location = headlessEvent.event;
      print('- Location: $location');
      break;
    case bg.Event.GEOFENCE:
      bg.GeofenceEvent geofenceEvent = headlessEvent.event;
      print('- GeofenceEvent: $geofenceEvent');
      break;
    case bg.Event.GEOFENCESCHANGE:
      bg.GeofencesChangeEvent event = headlessEvent.event;
      print('- GeofencesChangeEvent: $event');
      break;
    case bg.Event.SCHEDULE:
      bg.State state = headlessEvent.event;
      print('- State: $state');
      break;
    case bg.Event.ACTIVITYCHANGE:
      bg.ActivityChangeEvent event = headlessEvent.event;
      print('ActivityChangeEvent: $event');
      break;
    case bg.Event.HTTP:
      bg.HttpEvent response = headlessEvent.event;
      print('HttpEvent: $response');
      break;
    case bg.Event.POWERSAVECHANGE:
      bool enabled = headlessEvent.event;
      print('ProviderChangeEvent: $enabled');
      break;
    case bg.Event.CONNECTIVITYCHANGE:
      bg.ConnectivityChangeEvent event = headlessEvent.event;
      print('ConnectivityChangeEvent: $event');
      break;
    case bg.Event.ENABLEDCHANGE:
      bool enabled = headlessEvent.event;
      print('EnabledChangeEvent: $enabled');
      break;
  }
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
