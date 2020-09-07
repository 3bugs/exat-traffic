import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';

import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/screens/scaffold.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/components/error_view.dart';
import 'package:exattraffic/storage/widget_prefs.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/storage/util_prefs.dart';
import 'package:exattraffic/screens/consent/consent_page.dart';
import 'package:exattraffic/screens/widget/widget.dart';
import 'package:exattraffic/models/language_model.dart';

//use Navigator.pushReplacement(BuildContext context, Route<T> newRoute) to open a new route which replace the current route of the navigator

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return wrapSystemUiOverlayStyle(child: SplashMain());
  }
}

class SplashMain extends StatefulWidget {
  @override
  _SplashMainState createState() => _SplashMainState();
}

class _SplashMainState extends State<SplashMain> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  String _splashImageUrl;

  //bool _isError = false;
  ErrorView _errorView;
  String _loadingMessage;

  @override
  void initState() {
    super.initState();

    doFirstRun();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
      value: 0.1,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });

    Future.delayed(const Duration(milliseconds: 200), () async {
      _checkNetwork();
    });
  }

  void doFirstRun() {
    Future.delayed(Duration.zero, () async {
      UtilPrefs utilPrefs = Provider.of<UtilPrefs>(context, listen: false);
      WidgetPrefs widgetPrefs = Provider.of<WidgetPrefs>(context, listen: false);

      if (await utilPrefs.isFirstRun()) {
        await widgetPrefs.addId(WidgetType.expressWay.toString());
        await utilPrefs.setFirstRunAlready();
      }
    });
  }

  void _checkNetwork() async {
    setState(() {
      _errorView = null;
      _loadingMessage = "Checking network availability";
    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _errorView = ErrorView(
          title: "ไม่มีการเชื่อมต่อเครือข่าย!",
          text:
          "${AppBloc.appName} ไม่สามารถทำงานได้ หากไม่มีการเชื่อมต่อเครือข่าย กรุณาตรวจสอบการเชื่อมต่อ แล้วลองใหม่",
          buttonText: "ลองใหม่",
          onClick: () => _checkNetwork(),
        );
      });
    } else {
      _fetchServerIp();
    }
  }

  void _fetchServerIp() async {
    setState(() {
      _errorView = null;
      _loadingMessage = "Fetching server's IP address";
    });

    try {
      Constants.Api.SERVER = await MyApi.fetchServerIp();
    } catch (_) {
      Constants.Api.SERVER = "http://202.94.76.78";
    }
    _checkUserConsent();
  }

  void _checkUserConsent() async {
    UtilPrefs utilPrefs = UtilPrefs();
    if (await utilPrefs.userConsent()) {
      _fetchSplashData(context);
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, anim1, anim2) => ConsentPage(),
        ),
      ).then((consent) {
        if (consent == true) {
          utilPrefs.setUserConsentAlready();
          _fetchSplashData(context);
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      });
    }
  }

  void _fetchSplashData(BuildContext context) async {
    setState(() {
      _errorView = null;
      _loadingMessage = "Fetching splash data";
    });

    GeolocationStatus geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    if (geolocationStatus == GeolocationStatus.granted) {
      try {
        ExatApi.fetchSplash(context).then((dataList) {
          print('SPLASH SCREEN FETCHED');

          setState(() {
            _splashImageUrl = '${dataList[0]['cover']}';
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
          _splashImageUrl = '${dataList[0]['cover']}';
        });
      } catch (_) {
        print('ERROR LOADING SPLASH SCREEN');
      }
    }

    //Future.delayed(Duration.zero, () {
    _loadMapsData();
    //});
  }

  void _loadMapsData() {
    setState(() {
      _errorView = null;
      _loadingMessage = "Fetching EXAT maps data";
    });
    context.bloc<AppBloc>().add(FetchMarker(context: context));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is FetchMarkerSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyScaffold(),
            ),
          );
        } else if (state is FetchMarkerFailure) {
          setState(() {
            _errorView = ErrorView(
              title: "ขออภัย",
              text:
              "${AppBloc.appName} ไม่สามารถอ่านข้อมูลจาก Server ได้ [${state.message}]",
              buttonText: "ลองใหม่",
              onClick: () => _loadMapsData(),
            );
          });
          //alert(context, "Error", state.message);
        }
      },
      child: Scaffold(
        appBar: null,
        //backgroundColor: Colors.blue,
        body: DecoratedBox(
          position: DecorationPosition.background,
          decoration: BoxDecoration(
            //color: Colors.red,
            image: DecorationImage(
              image: AssetImage('assets/images/login/bg_login_2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              //horizontal: getPlatformSize(Constants.LoginScreen.HORIZONTAL_MARGIN),
              horizontal: 0.0,
              vertical: 0.0,
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ScaleTransition(
                        scale: _animation,
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage('assets/images/splash/exat_logo_new.png'),
                          width: getPlatformSize(Constants.LoginScreen.LOGO_SIZE),
                          height: getPlatformSize(Constants.LoginScreen.LOGO_SIZE),
                        ),
                      ),
                      /*SizedBox(
                    height: getPlatformSize(28.0),
                  ),
                  CircularProgressIndicator(),*/
                    ],
                  ),
                ),
                _splashImageUrl != null
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: getPlatformSize(32.0),
                          horizontal: getPlatformSize(20.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(_splashImageUrl),
                              fit: BoxFit.contain,
                            ),
                          ),
                          /*child: Center(
                            child: CircularProgressIndicator(),
                          ),*/
                        ),
                      )
                    : SizedBox.shrink(),
                _errorView != null
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: getPlatformSize(Constants.LoginScreen.HORIZONTAL_MARGIN),
                          vertical: 0.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            _errorView
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                Visibility(
                  visible:
                      _loadingMessage != null && _loadingMessage.isNotEmpty && _errorView == null,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getPlatformSize(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: getPlatformSize(16.0),
                            height: getPlatformSize(16.0),
                            child: CircularProgressIndicator(
                              strokeWidth: getPlatformSize(3),
                              backgroundColor: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          SizedBox(
                            width: getPlatformSize(8.0),
                          ),
                          Text(
                            _loadingMessage ?? "", //'Loading...',
                            style: getTextStyle(
                              LanguageName.english,
                              sizeTh: Constants.Font.SMALLER_SIZE_TH,
                              sizeEn: Constants.Font.SMALLER_SIZE_EN,
                              color: Colors.white.withOpacity(0.5),
                              //isBold: true,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
