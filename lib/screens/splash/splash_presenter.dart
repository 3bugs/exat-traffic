import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/notification_model.dart';
import 'package:exattraffic/components/error_view.dart';
import 'package:exattraffic/storage/util_prefs.dart';
import 'package:exattraffic/storage/widget_prefs.dart';
import 'package:exattraffic/screens/consent/consent_page.dart';
import 'package:exattraffic/screens/settings/settings.dart';
import 'package:exattraffic/screens/widget/widget.dart';

import 'splash.dart';

class SplashPresenter extends BasePresenter<SplashMain> {
  List<NotificationModel> notificationList;

  String splashImageUrl;
  Widget errorView;
  String loadingMessage;

  SplashPresenter(State<SplashMain> state) : super(state);

  void doFirstRun() {
    Future.delayed(Duration.zero, () async {
      UtilPrefs utilPrefs = Provider.of<UtilPrefs>(state.context, listen: false);
      WidgetPrefs widgetPrefs = Provider.of<WidgetPrefs>(state.context, listen: false);

      if (await utilPrefs.isFirstRun()) {
        await widgetPrefs.addId(WidgetType.expressWay.toString());
        await utilPrefs.setFirstRunAlready();
        await utilPrefs.setNotificationStatus(true);
      }
    });
  }

  void bootstrap() {
    checkNetwork();
  }

  void checkNetwork() async {
    setState(() {
      errorView = null;
      loadingMessage = "Checking network availability";
    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        errorView = ErrorView(
          title: "ไม่มีการเชื่อมต่อเครือข่าย!",
          text:
          "${AppBloc.appName} ไม่สามารถทำงานได้ หากไม่มีการเชื่อมต่อเครือข่าย กรุณาตรวจสอบการเชื่อมต่อ แล้วลองใหม่",
          buttonText: "ลองใหม่",
          onClick: () => checkNetwork(),
        );
      });
    } else {
      fetchServerIp();
    }
  }

  void fetchServerIp() async {
    /*setState(() {
      errorView = null;
      loadingMessage = "Fetching server's IP address";
    });

    try {
      Constants.Api.SERVER = await MyApi.fetchServerIp();
    } catch (_) {
      Constants.Api.SERVER = "http://202.94.76.78";
    }*/
    checkUserConsent();
  }

  void checkUserConsent() async {
    UtilPrefs utilPrefs = UtilPrefs();
    if (await utilPrefs.userConsent()) {
      fetchSplashData(state.context);
    } else {
      Navigator.push(
        state.context,
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, anim1, anim2) => ConsentPage(isFirstRun: true),
        ),
      ).then((consent) {
        if (consent == true) {
          utilPrefs.setUserConsentAlready();
          selectLanguage();
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      });
    }
  }

  void selectLanguage() {
    Navigator.push(
      state.context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (context, anim1, anim2) => Settings(isFirstRun: true),
      ),
    ).then((consent) {
      fetchSplashData(state.context);
    });
  }

  void fetchSplashData(BuildContext context) async {
    setState(() {
      errorView = null;
      loadingMessage = "Fetching splash data";
    });

    GeolocationStatus geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    if (geolocationStatus == GeolocationStatus.granted) {
      try {
        ExatApi.fetchSplash(context).then((dataList) {
          print('SPLASH SCREEN FETCHED');

          setState(() {
            splashImageUrl = '${dataList[0]['cover']}';
          });
        });
      } catch (_) {
        print('ERROR LOADING SPLASH SCREEN');
      }
    } else {
      try {
        List dataList = await ExatApi.fetchSplash(context);
        print('SPLASH SCREEN FETCHED');

        setState(() {
          splashImageUrl = '${dataList[0]['cover']}';
        });
      } catch (_) {
        print('ERROR LOADING SPLASH SCREEN');
      }
    }

    //Future.delayed(Duration.zero, () {
    loadMapsData();
    //});
  }

  void loadMapsData() {
    setState(() {
      errorView = null;
      loadingMessage = "Fetching EXAT maps data";
    });
    state.context.bloc<AppBloc>().add(FetchMarker(context: state.context));
  }
}
