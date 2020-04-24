import 'package:flutter/material.dart';
import 'package:exattraffic/etc/utils.dart';
import '../../constants.dart' as Constants;
import 'package:intl/intl.dart';
//import 'package:intl/date_symbol_data_local.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return wrapSystemUiOverlayStyle(child: HomeMain());
  }
}

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  List<Color> _bgGradientColors = const [
    Constants.App.HEADER_GRADIENT_COLOR_START,
    Constants.App.HEADER_GRADIENT_COLOR_END,
  ];
  List<double> _bgGradientStops = const [0.0, 1.0];

  String formattedDate = new DateFormat.yMMMMd().format(new DateTime.now()).toUpperCase();

  @override
  Widget build(BuildContext context) {
    //initializeDateFormatting("fr_FR", null).then((_) => runMyCode());

    return Scaffold(
      appBar: null,
      /*AppBar(
        title: Text('Home'),
      )*/
      drawer: Drawer(
        child: MyDrawer(),
      ),
      bottomNavigationBar: MyNavBar(),
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _bgGradientColors,
            stops: _bgGradientStops,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                    left: Constants.App.HORIZONTAL_MARGIN,
                    right: Constants.App.HORIZONTAL_MARGIN,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: getPlatformSize(3.0),
                            right: getPlatformSize(3.0),
                            top: getPlatformSize(16.0),
                            bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/images/home/ic_menu.png'),
                              width: getPlatformSize(22.0),
                              height: getPlatformSize(20.0),
                            ),
                            Image(
                              image: AssetImage('assets/images/home/ic_phone_circle.png'),
                              width: getPlatformSize(36.0),
                              height: getPlatformSize(36.0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: getPlatformSize(3.0),
                        ),
                        child: Text(
                          'Home',
                          style: TextStyle(
                            fontSize: getPlatformSize(42.0),
                            color: Colors.white,
                            height: 0.95,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: getPlatformSize(5.0),
                        ),
                        child: Text(
                          formattedDate, //'APRIL 23, 2020',
                          style: TextStyle(
                            fontSize: getPlatformSize(16.0),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: Constants.HomeScreen.MAPS_VERTICAL_POSITION),
                      decoration: BoxDecoration(
                        //color: Color(0xFFF6F6F4),
                        color: Colors.yellow.shade100,
                      ),
                      child: Center(
                        child: Text(
                          'Google Maps\ncoming soon.\nʕ•́ᴥ•̀ʔっ♡',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: getPlatformSize(40.0),
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      top: 0.0,
                      left: 0.0,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: Constants.HomeScreen.SEARCH_BOX_VERTICAL_POSITION,
                          left: Constants.App.HORIZONTAL_MARGIN,
                          right: Constants.App.HORIZONTAL_MARGIN,
                        ),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x22777777),
                                blurRadius: getPlatformSize(10.0),
                                spreadRadius: getPlatformSize(5.0),
                                offset: Offset(
                                  getPlatformSize(2.0), // move right
                                  getPlatformSize(2.0), // move down
                                ),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(Constants.App.BOX_BORDER_RADIUS),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: getPlatformSize(10.0),
                            bottom: getPlatformSize(10.0),
                            left: getPlatformSize(20.0),
                            right: getPlatformSize(16.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                image: AssetImage('assets/images/home/ic_search.png'),
                                width: getPlatformSize(16.0),
                                height: getPlatformSize(16.0),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: getPlatformSize(16.0),
                                    right: getPlatformSize(16.0),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: getPlatformSize(4.0),
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'ค้นหา',
                                    ),
                                  ),
                                ),
                              ),
                              Image(
                                image: AssetImage('assets/images/home/ic_close_search.png'),
                                width: getPlatformSize(24.0),
                                height: getPlatformSize(24.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Drawer Header'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            // Update the state of the app.
            // ...
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {
            // Update the state of the app.
            // ...
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class MyNavBarItem extends StatefulWidget {
  MyNavBarItem(
      {@required this.icon,
      @required this.iconWidth,
      @required this.iconHeight,
      @required this.label});

  final AssetImage icon;
  final double iconWidth;
  final double iconHeight;
  final String label;

  @override
  State createState() => _MyNavBarItemState();
}

class _MyNavBarItemState extends State<MyNavBarItem> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyNavBar extends StatefulWidget {
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
        ],
      ),
    );
  }
}
