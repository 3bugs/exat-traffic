import 'package:flutter/material.dart';
import 'package:exattraffic/etc/utils.dart';

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
  List<Color> _bgGradientColors = [Color(0xFF5574F7), Color(0xFF60C3FF)];
  List<double> _bgGradientStops = [0.0, 1.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      /*AppBar(
        title: Text('Home'),
      )*/
      drawer: Drawer(
        child: MyDrawer(),
      ),
      bottomNavigationBar: SizedBox(
        height: getPlatformSize(77.2),
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: getPlatformSize(77.2),
              child: BottomNavigationBar(
                currentIndex: 0,
                type: BottomNavigationBarType.fixed,
                elevation: getPlatformSize(200.0),
                backgroundColor: Colors.white,
                items: [
                  _getNavBarItem(
                    icon:
                        AssetImage('assets/images/nav_bar/ic_nav_home_on.png'),
                    iconWidth: 24.5,
                    iconHeight: 21.0,
                    label: 'Home',
                  ),
                  _getNavBarItem(
                    icon: AssetImage(
                        'assets/images/nav_bar/ic_nav_favorite_off.png'),
                    iconWidth: 21.0,
                    iconHeight: 21.0,
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
                    icon: AssetImage(
                        'assets/images/nav_bar/ic_nav_incident_off.png'),
                    iconWidth: 16.0,
                    iconHeight: 21.0,
                    label: 'Incident',
                  ),
                  _getNavBarItem(
                    icon: AssetImage(
                        'assets/images/nav_bar/ic_nav_notification_off.png'),
                    iconWidth: 21.0,
                    iconHeight: 21.0,
                    label: 'Notification',
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text('Test'),
            ),
            /*Positioned(
              left: 50, top: 10,
              child: Text('Test'),
            ),*/
          ],
        ),
      ),
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: _bgGradientColors,
          stops: _bgGradientStops,
        )),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      left: getPlatformSize(24.0),
                      right: getPlatformSize(24.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: getPlatformSize(5.0),
                            right: getPlatformSize(5.0),
                            top: getPlatformSize(16.0),
                            bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image(
                              image:
                                  AssetImage('assets/images/home/ic_menu.png'),
                              width: getPlatformSize(22.0),
                              height: getPlatformSize(20.0),
                            ),
                            Image(
                              image: AssetImage(
                                  'assets/images/home/ic_phone_circle.png'),
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
                            fontSize: getPlatformSize(44.0),
                            color: Color(0xFFFFFFFF),
                            height: 0.95,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: getPlatformSize(5.0),
                        ),
                        child: Text(
                          'APRIL 23, 2020',
                          style: TextStyle(
                            fontSize: getPlatformSize(16.0),
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: getPlatformSize(42.0)),
                      // ตำแหน่ง maps
                      decoration: BoxDecoration(
                        color: Color(0xFFF6F6F4),
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
                          top: getPlatformSize(16.0), // ตำแหน่งช่อง SEARCH
                          left: getPlatformSize(24.0),
                          right: getPlatformSize(24.0),
                        ),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x22777777),
                                blurRadius: getPlatformSize(10.0),
                                // has the effect of softening the shadow
                                spreadRadius: getPlatformSize(5.0),
                                // has the effect of extending the shadow
                                offset: Offset(
                                  getPlatformSize(2.0),
                                  // horizontal, move right 10
                                  getPlatformSize(
                                      2.0), // vertical, move down 10
                                ),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(getPlatformSize(12.0)),
                              topRight: Radius.circular(getPlatformSize(12.0)),
                              bottomLeft:
                                  Radius.circular(getPlatformSize(12.0)),
                              bottomRight:
                                  Radius.circular(getPlatformSize(12.0)),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: getPlatformSize(10.0),
                            left: getPlatformSize(20.0),
                            right: getPlatformSize(16.0),
                            bottom: getPlatformSize(10.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                image: AssetImage(
                                    'assets/images/home/ic_search.png'),
                                width: getPlatformSize(16.0),
                                height: getPlatformSize(16.0),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: getPlatformSize(16.0),
                                      right: getPlatformSize(16.0)),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: getPlatformSize(4.0)),
                                        border: InputBorder.none,
                                        hintText: 'ค้นหา'),
                                  ),
                                ),
                              ),
                              Image(
                                image: AssetImage(
                                    'assets/images/home/ic_close_search.png'),
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

/*Center(
  child: Text(
    'แผนที่\nGoogle\nMaps',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 60,
      color: Color(0xFF444444),
    ),
  ),
),
RaisedButton(
  onPressed: () {
    Scaffold.of(context).openDrawer();
  },
  child: Text('Open Drawer'),
),
RaisedButton(
  onPressed: () {
    Navigator.pop(context);
  },
  child: Text('Go back!'),
),*/

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
