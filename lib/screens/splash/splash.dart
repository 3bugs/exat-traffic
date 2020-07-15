import 'dart:async';
import 'dart:convert';
import 'package:exattraffic/models/category_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/screens/scaffold.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/screens/home/home.dart';
import 'package:exattraffic/constants.dart' as Constants;

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

  @override
  void initState() {
    super.initState();

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

    Future.delayed(const Duration(milliseconds: 1000), () {
      _fetchSplashData(context);
    });
  }

  void _fetchSplashData(BuildContext context) async {
    GeolocationStatus geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    if (geolocationStatus == GeolocationStatus.granted) {
      try {
        ExatApi.fetchSplash(context).then((dataMap) {
          setState(() {
            _splashImageUrl = 'http://163.47.9.26${dataMap['cover']}';
          });
        });
      } catch (_) {
        // do nothing
      }
    } else {
      try {
        Map<String, dynamic> dataMap = await ExatApi.fetchSplash(context);
        setState(() {
          _splashImageUrl = 'http://163.47.9.26${dataMap['cover']}';
        });
      } catch (_) {
        // do nothing
      }
    }

    //Future.delayed(Duration.zero, () {
    context.bloc<AppBloc>().add(FetchMarker(context: context));
    //});
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
          alert(context, "Error", state.message);
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
              image: AssetImage('assets/images/login/bg_login.jpg'),
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
                          image: AssetImage('assets/images/login/exat_logo.png'),
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
                        padding: EdgeInsets.all(getPlatformSize(24.0)),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(_splashImageUrl),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
