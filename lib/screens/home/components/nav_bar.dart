import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

class MyNavBar extends StatefulWidget {
  MyNavBar({
    @required this.onClickTab,
  });

  final Function onClickTab;

  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  List<Color> _bgNavCenterItemColors = const [Color(0xFFFFFFFF), Color(0x00FFFFFF)];
  List<double> _bgNavCenterItemStops = const [0.3, 0.4];

  int _currentTabIndex = 0;

  void handlePressTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });
    widget.onClickTab(index);
  }

  BottomNavigationBarItem _getNavBarItem({
    @required AssetImage icon,
    @required double iconWidth,
    @required double iconHeight,
    @required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Image(
        image: icon,
        width: getPlatformSize(iconWidth),
        height: getPlatformSize(iconHeight),
      ),
      title: Padding(
        padding: EdgeInsets.only(top: getPlatformSize(5.0)),
        child: Text(
          label,
          style: TextStyle(
            fontSize: getPlatformSize(14.0),
          ),
        ),
      ),
    );
  }

  double getIconSizeByState(bool state, double size) {
    return state ? size * 1.25 : size;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Constants.NavBar.HEIGHT,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          SizedBox(
            height: Constants.NavBar.HEIGHT,
            child: BottomNavigationBar(
              currentIndex: _currentTabIndex,
              onTap: handlePressTab,
              type: BottomNavigationBarType.fixed,
              elevation: getPlatformSize(50.0),
              backgroundColor: Colors.white,
              items: [
                _getNavBarItem(
                  icon: _currentTabIndex == 0
                      ? AssetImage('assets/images/nav_bar/ic_nav_home_on.png')
                      : AssetImage('assets/images/nav_bar/ic_nav_home_off.png'),
                  iconWidth: getIconSizeByState(_currentTabIndex == 0, getPlatformSize(25.5)),
                  iconHeight: getIconSizeByState(_currentTabIndex == 0, getPlatformSize(21.0)),
                  label: 'Home',
                ),
                _getNavBarItem(
                  icon: _currentTabIndex == 1
                      ? AssetImage('assets/images/nav_bar/ic_nav_favorite_on.png')
                      : AssetImage('assets/images/nav_bar/ic_nav_favorite_off.png'),
                  iconWidth: getIconSizeByState(_currentTabIndex == 1, getPlatformSize(22.0)),
                  iconHeight: getIconSizeByState(_currentTabIndex == 1, getPlatformSize(21.0)),
                  label: 'Favorite',
                ),
                BottomNavigationBarItem(
                  icon: Opacity(
                    opacity: 0.0,
                    child: Icon(Icons.home),
                  ),
                  title: Text(''),
                ),
                _getNavBarItem(
                  icon: _currentTabIndex == 3
                      ? AssetImage('assets/images/nav_bar/ic_nav_incident_on.png')
                      : AssetImage('assets/images/nav_bar/ic_nav_incident_off.png'),
                  iconWidth: getIconSizeByState(_currentTabIndex == 3, getPlatformSize(17.0)),
                  iconHeight: getIconSizeByState(_currentTabIndex == 3, getPlatformSize(21.0)),
                  label: 'Incident',
                ),
                _getNavBarItem(
                  icon: _currentTabIndex == 4
                      ? AssetImage('assets/images/nav_bar/ic_nav_notification_on.png')
                      : AssetImage('assets/images/nav_bar/ic_nav_notification_off.png'),
                  iconWidth: getIconSizeByState(_currentTabIndex == 4, getPlatformSize(21.0)),
                  iconHeight: getIconSizeByState(_currentTabIndex == 4, getPlatformSize(21.0)),
                  label: 'Notification',
                ),
              ],
            ),
          ),
          Positioned(
            top: Constants.NavBar.HEIGHT - Constants.NavBar.CENTER_ITEM_OUTER_SIZE,
            left: (MediaQuery.of(context).size.width - Constants.NavBar.CENTER_ITEM_OUTER_SIZE) / 2,
            child: Container(
              width: Constants.NavBar.CENTER_ITEM_OUTER_SIZE,
              height: Constants.NavBar.CENTER_ITEM_OUTER_SIZE,
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
                  Radius.circular(Constants.NavBar.CENTER_ITEM_OUTER_SIZE / 2),
                ),
              ),
              child: Center(
                child: Container(
                  width: Constants.NavBar.CENTER_ITEM_INNER_SIZE,
                  height: Constants.NavBar.CENTER_ITEM_INNER_SIZE,
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
                      Radius.circular(Constants.NavBar.CENTER_ITEM_INNER_SIZE / 2),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      //highlightColor: Constants.App.PRIMARY_COLOR,
                      borderRadius: BorderRadius.all(
                          Radius.circular(Constants.NavBar.CENTER_ITEM_INNER_SIZE / 2)),
                      child: Center(
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
        ],
      ),
    );
  }
}
