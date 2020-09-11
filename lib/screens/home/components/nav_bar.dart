import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/locale_text.dart';

LocaleText homeLabel = LocaleText.home();
LocaleText favoriteLabel = LocaleText.favorite();
LocaleText incidentLabel = LocaleText.incident();
LocaleText notificationLabel = LocaleText.notification();

class MyNavBar extends StatefulWidget {
  MyNavBar({
    @required this.currentTabIndex,
    @required this.onClickTab,
  });

  final int currentTabIndex;
  final Function onClickTab;

  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  List<Color> _bgNavCenterItemColors = const [Color(0xFFFFFFFF), Color(0x00FFFFFF)];
  List<double> _bgNavCenterItemStops = const [0.3, 0.4];
  bool _markerIconVisible = true;
  Timer _timer;
  //int _currentTabIndex = 0;

  void _handlePressTab(int index) {
    /*setState(() {
      _currentTabIndex = index;
    });*/
    widget.onClickTab(index);
  }

  void _startTimer() {
    _stopTimer();
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _markerIconVisible = !_markerIconVisible;
      });
    });
  }

  void _stopTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    _timer = null;
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  BottomNavigationBarItem _getNavBarItem({
    @required AssetImage icon,
    @required double iconWidth,
    @required double iconHeight,
    @required LocaleText label,
  }) {
    return BottomNavigationBarItem(
      icon: Image(
        image: icon,
        width: getPlatformSize(iconWidth),
        height: getPlatformSize(iconHeight),
      ),
      title: Padding(
        padding: EdgeInsets.only(top: getPlatformSize(5.0)),
        child: Consumer<LanguageModel>(builder: (context, language, child) {
          return Text(
            label.ofLanguage(language.lang),
            style: language.lang == LanguageName.thai
                ? TextStyle(
                    fontFamily: 'DBHeavent',
                    fontSize: getPlatformSize(Constants.Font.SMALLER_SIZE_TH),
                    height: 1.0,
                  )
                : TextStyle(
                    fontSize: getPlatformSize(Constants.Font.SMALLER_SIZE_EN),
                  ),
          );
        }),
      ),
    );
  }

  double getIconSizeByState(bool state, double size) {
    return state ? size * 1.25 : size;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      /*color: Colors.white,
      padding: EdgeInsets.only(
        bottom: 0.0, //MediaQuery.of(context).padding.bottom,
      ),*/
      child: SizedBox(
        height: getPlatformSize(Constants.NavBar.HEIGHT),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            SizedBox(
              height: getPlatformSize(Constants.NavBar.HEIGHT),
              child: BottomNavigationBar(
                currentIndex: widget.currentTabIndex,
                onTap: _handlePressTab,
                type: BottomNavigationBarType.fixed,
                elevation: getPlatformSize(0.0),
                backgroundColor: Colors.white,
                items: [
                  _getNavBarItem(
                    icon: widget.currentTabIndex == 0
                        ? AssetImage('assets/images/nav_bar/ic_nav_home_on.png')
                        : AssetImage('assets/images/nav_bar/ic_nav_home_off.png'),
                    iconWidth:
                        getIconSizeByState(widget.currentTabIndex == 0, getPlatformSize(25.5)),
                    iconHeight:
                        getIconSizeByState(widget.currentTabIndex == 0, getPlatformSize(21.0)),
                    label: homeLabel,
                  ),
                  _getNavBarItem(
                    icon: widget.currentTabIndex == 1
                        ? AssetImage('assets/images/nav_bar/ic_nav_favorite_on.png')
                        : AssetImage('assets/images/nav_bar/ic_nav_favorite_off.png'),
                    iconWidth:
                        getIconSizeByState(widget.currentTabIndex == 1, getPlatformSize(22.0)),
                    iconHeight:
                        getIconSizeByState(widget.currentTabIndex == 1, getPlatformSize(21.0)),
                    label: favoriteLabel,
                  ),
                  BottomNavigationBarItem(
                    icon: Opacity(
                      opacity: 0.0,
                      child: Icon(Icons.home),
                    ),
                    title: Text(''),
                  ),
                  _getNavBarItem(
                    icon: widget.currentTabIndex == 3
                        ? AssetImage('assets/images/nav_bar/ic_nav_incident_on.png')
                        : AssetImage('assets/images/nav_bar/ic_nav_incident_off.png'),
                    iconWidth:
                        getIconSizeByState(widget.currentTabIndex == 3, getPlatformSize(17.0)),
                    iconHeight:
                        getIconSizeByState(widget.currentTabIndex == 3, getPlatformSize(21.0)),
                    label: incidentLabel,
                  ),
                  _getNavBarItem(
                    icon: widget.currentTabIndex == 4
                        ? AssetImage('assets/images/nav_bar/ic_nav_notification_on.png')
                        : AssetImage('assets/images/nav_bar/ic_nav_notification_off.png'),
                    iconWidth:
                        getIconSizeByState(widget.currentTabIndex == 4, getPlatformSize(21.0)),
                    iconHeight:
                        getIconSizeByState(widget.currentTabIndex == 4, getPlatformSize(21.0)),
                    label: notificationLabel,
                  ),
                ],
              ),
            ),
            Positioned(
              top: getPlatformSize(Constants.NavBar.HEIGHT) -
                  getPlatformSize(Constants.NavBar.CENTER_ITEM_OUTER_SIZE),
              left: (MediaQuery.of(context).size.width -
                      getPlatformSize(Constants.NavBar.CENTER_ITEM_OUTER_SIZE)) /
                  2,
              child: Container(
                width: getPlatformSize(Constants.NavBar.CENTER_ITEM_OUTER_SIZE),
                height: getPlatformSize(Constants.NavBar.CENTER_ITEM_OUTER_SIZE),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: _bgNavCenterItemColors,
                    stops: _bgNavCenterItemStops,
                  ),
                  //color: Colors.pinkAccent.shade100,
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(getPlatformSize(Constants.NavBar.CENTER_ITEM_OUTER_SIZE / 2)),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: getPlatformSize(Constants.NavBar.CENTER_ITEM_INNER_SIZE),
                    height: getPlatformSize(Constants.NavBar.CENTER_ITEM_INNER_SIZE),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x50000000),
                          blurRadius: getPlatformSize(5.0),
                          spreadRadius: getPlatformSize(1.0),
                          offset: Offset(
                            getPlatformSize(0.0),
                            getPlatformSize(4.0),
                          ),
                        )
                      ],
                      color: Constants.App.PRIMARY_COLOR,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                            getPlatformSize(Constants.NavBar.CENTER_ITEM_INNER_SIZE / 2)),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _handlePressTab(2);
                        },
                        //highlightColor: Constants.App.PRIMARY_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(
                            getPlatformSize(Constants.NavBar.CENTER_ITEM_INNER_SIZE) / 2)),
                        child: Center(
                          child: AnimatedOpacity(
                            opacity: _markerIconVisible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: Image(
                              image: AssetImage('assets/images/nav_bar/ic_nav_marker.png'),
                              width: getPlatformSize(26.0),
                              height: getPlatformSize(26.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /*Positioned(
              top: getPlatformSize(Constants.NavBar.HEIGHT) -
                  getPlatformSize(Constants.NavBar.CENTER_ITEM_OUTER_SIZE),
              left: (MediaQuery.of(context).size.width -
                      getPlatformSize(Constants.NavBar.CENTER_ITEM_OUTER_SIZE)) /
                  2,
              child: SizedBox(
                width: getPlatformSize(Constants.NavBar.CENTER_ITEM_OUTER_SIZE),
                height: getPlatformSize(Constants.NavBar.CENTER_ITEM_OUTER_SIZE),
                child: Center(
                  child: SizedBox(
                    width: getPlatformSize(Constants.NavBar.CENTER_ITEM_INNER_SIZE),
                    height: getPlatformSize(Constants.NavBar.CENTER_ITEM_INNER_SIZE),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      strokeWidth: getPlatformSize(2.0),
                    ),
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
