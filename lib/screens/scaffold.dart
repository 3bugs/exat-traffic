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
import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/components/lazy_indexed_stack.dart';
import 'package:exattraffic/components/header.dart';
import 'package:exattraffic/components/search_box.dart';
import 'package:exattraffic/services/fcm.dart';
import 'package:exattraffic/screens/search/search_service.dart';
import 'package:exattraffic/screens/search/search_place.dart';
import 'package:exattraffic/screens/emergency/emergency.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/models/locale_text.dart';

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
    showSearch: true,
    title: LocaleText(
      thai: 'หน้าหลัก',
      english: 'Home',
      chinese: '家园',
    ),
    searchHint: LocaleText(
      thai: 'ค้นหา',
      english: 'Search',
      chinese: '搜索',
    ),
  ),
  ScreenProps(
    // favorite
    id: 1,
    showSearch: true,
    title: LocaleText(
      thai: 'รายการโปรด',
      english: 'Favorite',
      chinese: '喜爱',
    ),
    searchHint: LocaleText(
      thai: 'ค้นหา',
      english: 'Search',
      chinese: '搜索',
    ),
    /*searchHint: [
      'ค้นหารายการโปรด',
      'Search favorite',
      '搜索收藏',
    ],*/
  ),
  ScreenProps(
    // route
    id: 2,
    title: LocaleText(
      thai: 'เส้นทาง',
      english: 'Route',
      chinese: '路线',
    ),
  ),
  ScreenProps(
    // incident
    id: 3,
    showSearch: true,
    title: LocaleText(
      thai: 'เหตุการณ์',
      english: 'Incident',
      chinese: '事件',
    ),
    searchHint: LocaleText(
      thai: 'ค้นหา',
      english: 'Search',
      chinese: '搜索',
    ),
    /*searchHint: [
      'ค้นหาเหตุการณ์',
      'Search incident',
      '搜索事件',
    ],*/
  ),
  ScreenProps(
    // notification
    id: 4,
    showSearch: true,
    title: LocaleText(
      thai: 'การแจ้งเตือน',
      english: 'Notification',
      chinese: '通知',
    ),
    searchHint: LocaleText(
      thai: 'ค้นหา',
      english: 'Search',
      chinese: '搜索',
    ),
    /*searchHint: [
      'ค้นหาการแจ้งเตือน',
      'Search notification',
      '搜索通知',
    ],*/
  ),
];

LocaleText searchServiceText = LocaleText(
  thai: 'ค้นหาบริการ',
  english: 'Search Service',
  chinese: '搜索服务',
);

LocaleText searchPlaceText = LocaleText(
  thai: 'ค้นหาเส้นทาง',
  english: 'Search Place',
  chinese: '搜索地点',
);

class MyScaffoldMain extends StatefulWidget {
  MyScaffoldMain();

  @override
  _MyScaffoldMainState createState() => _MyScaffoldMainState();
}

class _MyScaffoldMainState extends State<MyScaffoldMain> {
  final GlobalKey _keyMainContainer = GlobalKey();
  final GlobalKey<MyHomeState> _keyHomePage = GlobalKey();
  final GlobalKey<FavoriteState> _keyFavoritePage = GlobalKey();
  final GlobalKey<MyRouteState> _keyRoutePage = GlobalKey();
  final GlobalKey<ScaffoldState> _keyDrawer = GlobalKey();

  final String formattedDate = new DateFormat.yMMMMd().format(new DateTime.now()).toUpperCase();

  static const List<Color> BG_GRADIENT_COLORS = [
    Constants.App.HEADER_GRADIENT_COLOR_START,
    Constants.App.HEADER_GRADIENT_COLOR_END,
  ];
  static const List<double> BG_GRADIENT_STOPS = [0.0, 1.0];

  List<Widget> _fragmentList;
  int _currentTabIndex = 0;
  ScreenProps _currentScreenProps = screenPropsList[0];
  bool _showSearchOptions = false;

  initState() {
    super.initState();

    new Future.delayed(Duration.zero, () {
      MyFcm(context).configFcm();
    });

    _fragmentList = [
      Home(_keyHomePage, hideSearchOptions, showBestRouteAfterSearch),
      Favorite(_keyFavoritePage, showBestRouteAfterSearch),
      MyRoute(_keyRoutePage, showBestRouteAfterSearch),
      Incident(),
      MyNotification(),
    ];

    /*Future.delayed(Duration.zero, () {
      int length = context.bloc<AppBloc>().markerList.length;
      alert(context, 'length', length.toString());
    });*/
  }

  void hideSearchOptions() {
    setState(() {
      _showSearchOptions = false;
    });
  }

  void _handleClickTab(int index) {
    _showFragment(index);

    /*if (index == 2) {
      if (_keyRoutePage.currentState != null) {
        _keyRoutePage.currentState.initRoute();
      } else {
        Future.delayed(Duration(milliseconds: 500), () {
          _keyRoutePage.currentState.initRoute();
        });
      }
    }*/
  }

  void _showFragment(int index) {
    if (index == 0 && _currentTabIndex == 0) {
      _keyHomePage.currentState.goHome();
    } else if (index == 1) {
      if (_keyFavoritePage.currentState != null) {
        _keyFavoritePage.currentState.onRefresh();
      }
    }

    setState(() {
      if (index != _currentTabIndex) {
        _showSearchOptions = false;
      }
      _currentTabIndex = index;
      _currentScreenProps = screenPropsList[index];
    });
  }

  void _handleClickSearchOption(int index) {
    Widget destination;

    setState(() {
      _showSearchOptions = false;
    });

    switch (index) {
      case 0:
        destination = SearchService(
          categoryList: context.bloc<AppBloc>().categoryList,
          markerList: context.bloc<AppBloc>().markerList,
        );
        break;
      case 1:
        destination = SearchPlace();
        break;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (context, anim1, anim2) => destination,
      ),
    ).then((bestRoute) {
      if (index == 1 && bestRoute != null) {
        showBestRouteAfterSearch(bestRoute);
      }
    });
  }

  void showBestRouteAfterSearch(RouteModel bestRoute) {
    _showFragment(2);
    if (_keyRoutePage.currentState != null) {
      _keyRoutePage.currentState.initFindRoute(bestRoute);
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        _keyRoutePage.currentState.initFindRoute(bestRoute);
      });
    }
  }

  Future<bool> _handleBackPressed() async {
    if (_keyDrawer.currentState.isDrawerOpen) {
      Navigator.pop(context);
      return Future.value(false);
    }
    if (_showSearchOptions) {
      hideSearchOptions();
      return Future.value(false);
    }
    if (_currentTabIndex != 0) {
      _handleClickTab(0);
      return Future.value(false);
    }

    LanguageName lang = Provider.of<LanguageModel>(context, listen: false).lang;

    LocaleText confirmText = LocaleText(
      thai: 'ต้องการออกจาก ${AppBloc.appName}?',
      english: 'Are you sure you want to exit?',
      chinese: '你确定要离开？',
    );
    LocaleText yesText = LocaleText(
      thai: 'ใช่',
      english: 'YES',
      chinese: '是',
    );
    LocaleText noText = LocaleText(
      thai: 'ไม่ใช่',
      english: 'NO',
      chinese: '没有',
    );

    List<DialogButtonModel> dialogButtonList = [
      DialogButtonModel(text: noText.ofLanguage(lang), value: DialogResult.no),
      DialogButtonModel(text: yesText.ofLanguage(lang), value: DialogResult.yes)
    ];
    return await showMyDialog(
          context,
          confirmText.ofLanguage(lang),
          dialogButtonList,
        ) ==
        DialogResult.yes;
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
        return WillPopScope(
          onWillPop: _handleBackPressed,
          child: Scaffold(
            key: _keyDrawer,
            // prevent keyboard from pushing layout up
            resizeToAvoidBottomInset: false,
            appBar: null,
            /*AppBar(
                title: Text('Home'),
              )*/
            drawer: Drawer(
              child: MyDrawer(),
            ),
            bottomNavigationBar: MyNavBar(
              currentTabIndex: _currentTabIndex,
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
                    Consumer<LanguageModel>(
                      builder: (context, language, child) {
                        return Header(
                          title: _currentScreenProps.title.ofLanguage(language.lang),
                          showDate: false,
                          leftIcon: HeaderIcon(
                            image: AssetImage('assets/images/home/ic_menu.png'),
                            onClick: () {
                              _keyDrawer.currentState.openDrawer();
                            },
                          ),
                          rightIcon: HeaderIcon(
                            image: AssetImage('assets/images/home/ic_phone_circle.png'),
                            onClick: () {
                              //Provider.of<LanguageModel>(context, listen: false).nextLang();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Emergency(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

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

                          // ช่อง search
                          Visibility(
                            visible: _currentScreenProps.showSearch,
                            child: SearchBox(
                              onClickBox: () {
                                setState(() {
                                  _showSearchOptions = !_showSearchOptions;
                                });
                              },
                              onClickCloseButton: () {
                                setState(() {
                                  _showSearchOptions = false;
                                });
                              },
                              child: Consumer<LanguageModel>(
                                builder: (context, language, child) {
                                  return Text(
                                    _currentScreenProps.searchHint.ofLanguage(language.lang),
                                    style: getTextStyle(
                                      language.lang,
                                      color: Constants.Font.DIM_COLOR,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // ตัวเลือกการค้นหา (บริการผู้ใช้ทาง/เส้นทาง)
                          Visibility(
                            visible: _showSearchOptions,
                            child: Positioned(
                              width: MediaQuery.of(context).size.width,
                              top: getPlatformSize(66.0),
                              left: 0.0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                                  right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x22777777),
                                        blurRadius: getPlatformSize(6.0),
                                        spreadRadius: getPlatformSize(3.0),
                                        offset: Offset(
                                          getPlatformSize(1.0), // move right
                                          getPlatformSize(1.0), // move down
                                        ),
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      // ค้นหาบริการผู้ใช้ทาง
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => _handleClickSearchOption(0),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                                            topRight: Radius.circular(
                                                getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: getPlatformSize(18.0),
                                              horizontal: getPlatformSize(20.0),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: getPlatformSize(10.0),
                                                  height: getPlatformSize(10.0),
                                                  margin: EdgeInsets.only(
                                                    right: getPlatformSize(16.0),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF3497FD),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(getPlatformSize(3.0)),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Consumer<LanguageModel>(
                                                    builder: (context, language, child) {
                                                      return Text(
                                                        searchServiceText.ofLanguage(language.lang),
                                                        style: getTextStyle(
                                                          language.lang,
                                                          color: Color(0xFF454F63),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // เส้นคั่น
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: getPlatformSize(20.0),
                                          right: getPlatformSize(20.0),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color(0xFFF4F4F4),
                                              width: getPlatformSize(1.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // ค้นหาเส้นทาง
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => _handleClickSearchOption(1),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(
                                                getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                                            bottomRight: Radius.circular(
                                                getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: getPlatformSize(18.0),
                                              horizontal: getPlatformSize(20.0),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: getPlatformSize(10.0),
                                                  height: getPlatformSize(10.0),
                                                  margin: EdgeInsets.only(
                                                    right: getPlatformSize(16.0),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF3ACCE1),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(getPlatformSize(3.0)),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Consumer<LanguageModel>(
                                                    builder: (context, language, child) {
                                                      return Text(
                                                        searchPlaceText.ofLanguage(language.lang),
                                                        style: getTextStyle(
                                                          language.lang,
                                                          color: Color(0xFF454F63),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
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
          ),
        );
      },
    );
  }
}
