import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/screens/scaffold.dart';
import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/components/error_view.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/locale_text.dart';

import 'splash_presenter.dart';

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
  SplashPresenter _presenter;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _presenter = SplashPresenter(this);
    _presenter.doFirstRun();

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
      _presenter.bootstrap();
    });
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
            _presenter.errorView = Consumer<LanguageModel>(
              builder: (context, language, child) {
                return ErrorView(
                  title: LocaleText.error().ofLanguage(language.lang),
                  text: LocaleText.cantFetchDataFromServer().ofLanguage(language.lang) +
                      ' [${state.message}]',
                  buttonText: LocaleText.tryAgain().ofLanguage(language.lang),
                  onClick: () => _presenter.loadMapsData(),
                );
              },
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
                _presenter.splashImageUrl != null
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: getPlatformSize(32.0),
                          horizontal: getPlatformSize(20.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(_presenter.splashImageUrl),
                              fit: BoxFit.contain,
                            ),
                          ),
                          /*child: Center(
                            child: CircularProgressIndicator(),
                          ),*/
                        ),
                      )
                    : SizedBox.shrink(),
                _presenter.errorView != null
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: getPlatformSize(Constants.LoginScreen.HORIZONTAL_MARGIN),
                          vertical: 0.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[_presenter.errorView],
                        ),
                      )
                    : SizedBox.shrink(),
                Visibility(
                  visible: _presenter.loadingMessage != null &&
                      _presenter.loadingMessage.isNotEmpty &&
                      _presenter.errorView == null,
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
                            _presenter.loadingMessage ?? "", //'Loading...',
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
