import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  void _fetchSplashData() async {
    final String url = 'http://163.47.9.26:8081/posts/detailByName';

    Map data = {
      "deviceToken": "testToken",
      "deviceType": "A",
      "screenWidth": "480",
      "screenHeight": "720",
      "lang": "TH",
      "lat": "13.66237545",
      "lng": "100.6431732",
      "altitude": "",
      "status": "1",
      "name": "splashscreen",
    };
    final body = json.encode(data);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer 84a65e5a9f8dac91c9f573aa417a246e",
      },
      body: body,
    );

    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print("${response.statusCode}");
    print("${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJsonBody = json.decode(response.body);
      if (responseJsonBody['status_code'].toString() == '200') {
        setState(() {
          _splashImageUrl = 'http://163.47.9.26${responseJsonBody['data']['cover']}';
        });
      } else {
        // handle error
      }
    } else {
      // handle error
    }

    Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyScaffold()),
      );
    });
  }

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
    Future.delayed(Duration.zero, () {
      _controller.forward();
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      _fetchSplashData();
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Visibility(
                visible: _splashImageUrl != null,
                child: _splashImageUrl != null
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
