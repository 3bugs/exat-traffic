import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/components/lazy_indexed_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:google_fonts/google_fonts.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/screens/home/home.dart';
import 'package:exattraffic/screens/home/components/drawer.dart';
import 'package:exattraffic/screens/home/components/nav_bar.dart';
import 'package:exattraffic/screens/favorite/favorite.dart';
import 'package:exattraffic/screens/incident/incident.dart';
import 'package:exattraffic/screens/notification/notification.dart';
import 'package:exattraffic/screens/route/route.dart';
import 'package:exattraffic/models/screen_props.dart';

//import 'package:exattraffic/components/fade_indexed_stack.dart';
//import 'package:exattraffic/components/animated_indexed_stack.dart';

//https://medium.com/flutter-community/implement-real-time-location-updates-on-google-maps-in-flutter-235c8a09173e
//https://medium.com/@CORDEA/implement-backdrop-with-flutter-73b4c61b1357
//https://codewithandrea.com/articles/2018-09-13-bottom-bar-navigation-with-fab/
//https://medium.com/flutter/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124

class MyScaffold extends StatelessWidget {
  MyScaffold();

  @override
  Widget build(BuildContext context) {
    return wrapSystemUiOverlayStyle(child: MyScaffoldMain());
  }
}

List<ScreenProps> screenPropsList = [
  ScreenProps(
    // home
    id: 0,
    showDate: false,
    titleList: [
      'หน้าหลัก',
      'Home',
      '家园',
    ],
    searchHintList: [
      'ค้นหา',
      'Search',
      '搜索',
    ],
  ),
  ScreenProps(
    // favorite
    id: 1,
    showDate: false,
    titleList: [
      'รายการโปรด',
      'Favorite',
      '喜爱',
    ],
    searchHintList: [
      'ค้นหารายการโปรด',
      'Search favorite',
      '搜索收藏',
    ],
  ),
  ScreenProps(
    // route
    id: 2,
    showDate: false,
    titleList: [
      'เส้นทาง',
      'Route',
      '路线',
    ],
  ),
  ScreenProps(
    // incident
    id: 3,
    showDate: false,
    titleList: [
      'เหตุการณ์',
      'Incident',
      '事件',
    ],
    searchHintList: [
      'ค้นหาเหตุการณ์',
      'Search incident',
      '搜索事件',
    ],
  ),
  ScreenProps(
    // notification
    id: 4,
    showDate: true,
    titleList: [
      'การแจ้งเตือน',
      'Notification',
      '通知',
    ],
    searchHintList: [
      'ค้นหาการแจ้งเตือน',
      'Search notification',
      '搜索通知',
    ],
  ),
];

List<String> dateList = [
  '29 มิถุนายน 2563',
  'JUNE 29, 2020',
  '2020年6月29日',
];

class MyScaffoldMain extends StatefulWidget {
  MyScaffoldMain();

  @override
  _MyScaffoldMainState createState() => _MyScaffoldMainState();
}

class _MyScaffoldMainState extends State<MyScaffoldMain> {
  final GlobalKey _keyMainContainer = GlobalKey();
  final GlobalKey<ScaffoldState> _keyDrawer = GlobalKey();

  final String formattedDate = new DateFormat.yMMMMd().format(new DateTime.now()).toUpperCase();

  static const List<Color> BG_GRADIENT_COLORS = [
    Constants.App.HEADER_GRADIENT_COLOR_START,
    Constants.App.HEADER_GRADIENT_COLOR_END,
  ];
  static const List<double> BG_GRADIENT_STOPS = [0.0, 1.0];

  List<Widget> _fragmentList;

  double _mainContainerTop = 0; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  double _mainContainerHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  int _currentTabIndex = 0;
  ScreenProps _currentScreenProps = screenPropsList[0];

  initState() {
    //WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    _fragmentList = [
      Home(),
      Favorite(),
      MyRoute(
        onUpdateBottomSheet: null,
      ),
      Incident(),
      MyNotification(),
    ];

    /*Future.delayed(Duration.zero, () {
      int length = context.bloc<AppBloc>().markerList.length;
      alert(context, 'length', length.toString());
    });*/

    super.initState();
  }

  _afterLayout(_) {
    final RenderBox mainContainerRenderBox = _keyMainContainer.currentContext.findRenderObject();
    setState(() {
      _mainContainerTop = mainContainerRenderBox.localToGlobal(Offset.zero).dy;
      _mainContainerHeight = mainContainerRenderBox.size.height;
    });
  }

  void _handleClickTab(int index) {
    setState(() {
      _currentTabIndex = index;
      _currentScreenProps = screenPropsList[index];

      if (index != 0) {
        //_showSearchOptions = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /*
      Galaxy J7 Prime (5.5" @ 1920x1080) = 414 x 736 logical pixel @ 3.0 pixel ratio
      iPhone 7 Plus (5.5" @ 1920x1080) = 360 x 640 logical pixel @ 3.0 pixel ratio
    */
    final MediaQueryData queryData = MediaQuery.of(context);
    print('Device width: ${queryData.size.width}, ' +
        'height: ${queryData.size.height}, ' +
        'pixel ratio: ${queryData.devicePixelRatio}');

    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is FetchMarkerSuccess) {
          print("Number of Markers: ${context.bloc<AppBloc>().markerList.length}");
        }
        return Scaffold(
          key: _keyDrawer,
          appBar: null,
          /*AppBar(
          title: Text('Home'),
        )*/
          drawer: Drawer(
            child: MyDrawer(),
          ),
          bottomNavigationBar: MyNavBar(
            onClickTab: _handleClickTab,
          ),
          /*floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
        ),*/
          body: DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: BG_GRADIENT_COLORS,
                stops: BG_GRADIENT_STOPS,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  // หัวด้านบน (พื้นหลังไล่เฉดสีฟ้า)
                  Padding(
                      padding: EdgeInsets.only(
                        left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                        right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // ปุ่มเมนูแฮมเบอร์เกอร์, ปุ่มโทร
                          Padding(
                            padding: EdgeInsets.only(
                                left: getPlatformSize(0.0),
                                right: getPlatformSize(3.0),
                                top: getPlatformSize(16.0),
                                bottom: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          _keyDrawer.currentState.openDrawer();
                                        },
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(getPlatformSize(3.0)),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: getPlatformSize(3.0),
                                            right: getPlatformSize(12.0),
                                            top: getPlatformSize(6.0),
                                            bottom: getPlatformSize(8.0),
                                          ),
                                          child: Image(
                                            image: AssetImage('assets/images/home/ic_menu.png'),
                                            width: getPlatformSize(22.0),
                                            height: getPlatformSize(20.0),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Image(
                                      image: AssetImage('assets/images/login/exat_logo_no_text-w200.png'),
                                      width: getPlatformSize(24.0 * 20.0 / 17.6),
                                      height: getPlatformSize(24.0),
                                    ),
                                  ],
                                ),

                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Provider.of<LanguageModel>(context, listen: false).nextLang();
                                      /*setState(() {
                                      _lang++;
                                      if (_lang > headlineList.length - 1) {
                                        _lang = 0;
                                      }
                                    });*/
                                    },
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(getPlatformSize(18.0)),
                                    ),
                                    child: Image(
                                      image: AssetImage('assets/images/home/ic_phone_circle.png'),
                                      width: getPlatformSize(36.0),
                                      height: getPlatformSize(36.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // headline
                          Padding(
                            padding: EdgeInsets.only(
                              left: getPlatformSize(4.0),
                            ),
                            child: Consumer<LanguageModel>(
                              builder: (context, language, child) {
                                return Text(
                                  _currentScreenProps.getTitle(language.lang),
                                  style: _getHeadlineTextStyle(context, lang: language.lang),
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ),
                          // วันที่
                          Visibility(
                            visible: _currentScreenProps.showDate,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: getPlatformSize(5.0),
                              ),
                              child: Consumer<LanguageModel>(
                                builder: (context, language, child) {
                                  return Text(
                                    dateList[language.lang],
                                    //formattedDate,
                                    //'15 พฤษภาคม 2563',
                                    //'MAY 15, 2020',
                                    style: getTextStyle(
                                      language.lang,
                                      color: Colors.white,
                                      heightTh: 0.8,
                                      heightEn: 1.15,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )),

                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        // main container wrapper
                        Container(
                          margin: EdgeInsets.only(
                            top: getPlatformSize(Constants.HomeScreen.MAPS_VERTICAL_POSITION),
                          ),
                          decoration: BoxDecoration(
                            //color: Color(0xFFF6F6F4),
                            color: Colors.white,
                          ),
                          // main container
                          child: Container(
                            key: _keyMainContainer,
                            child: LazyIndexedStack(
                              //children: _fragmentList,
                              reuse: true,
                              itemBuilder: (context, index) {
                                return _fragmentList[index];
                              },
                              itemCount: 5,
                              index: _currentTabIndex,
                            ),
                          ),
                        ),

                        // เงาบนแถบ bottom nav
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            height: 0.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x22777777),
                                  blurRadius: getPlatformSize(20.0),
                                  spreadRadius: getPlatformSize(10.0),
                                  offset: Offset(
                                    getPlatformSize(0.0), // move right
                                    getPlatformSize(-2.0), // move down
                                  ),
                                ),
                              ],
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
      },
    );
  }

  TextStyle _getHeadlineTextStyle(BuildContext context, {int lang = 0}) {
    final bool isBigScreen =
        screenWidth(context) > getPlatformSize(400) && screenHeight(context) > getPlatformSize(700);

    return getTextStyle(
      lang,
      sizeTh: isBigScreen ? 55.0 : 44.0,
      sizeEn: isBigScreen ? 40.0 : 32.0,
      color: Colors.white,
      heightTh: 1.1,
      heightEn: 1.4,
    );
  }
}

/*class MapToolItem extends StatelessWidget {
  MapToolItem({
    @required this.icon,
    @required this.iconWidth,
    @required this.iconHeight,
    @required this.marginTop,
  });

  final AssetImage icon;
  final double iconWidth;
  final double iconHeight;
  final double marginTop;

  static const double SIZE = 45.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getPlatformSize(SIZE),
      height: getPlatformSize(SIZE),
      margin: EdgeInsets.only(
        top: marginTop,
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
            Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
          )),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          //highlightColor: Constants.App.PRIMARY_COLOR,
          borderRadius:
              BorderRadius.all(Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS))),
          child: Center(
            child: Image(
              image: icon,
              width: iconWidth,
              height: iconHeight,
            ),
          ),
        ),
      ),
    );
  }
}*/
