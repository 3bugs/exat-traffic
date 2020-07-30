import 'dart:async';
import 'dart:convert';

import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/home/home.dart';
import 'package:exattraffic/components/my_progress_indicator.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/services/api.dart';

// iOS setup
// Opt-in to the embedded views preview by adding a boolean property to
// the app's Info.plist file with the key io.flutter.embedded_views_preview and the value YES.

class SchematicMaps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return wrapSystemUiOverlayStyle(
      child: SchematicMapsMain(),
    );
  }
}

class SchematicMapsMain extends StatefulWidget {
  @override
  _SchematicMapsMainState createState() => _SchematicMapsMainState();
}

class _SchematicMapsMainState extends State<SchematicMapsMain> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool _showCctv = false;
  bool _isLoading = false;

  JavascriptChannel _cctvJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'CCTV',
      onMessageReceived: (JavascriptMessage jsMessage) async {
        print(jsMessage.message);

        int markerId = int.parse(jsMessage.message);
        List<MarkerModel> list =
            _getCctvList(context).where((cctv) => cctv.id == markerId).toList();
        //alert(context, "CCTV", list[0].name);

        assert(list.isNotEmpty);
        if (list.isNotEmpty) {
          list[0].showDetailsScreen(context);
        }

        // todo: fetch marker details & navigate to CCTV details page
        /*setState(() {
          _isLoading = true;
        });
        try {
          MarkerModel cctv = await ExatApi.fetchMarkerDetails(context, 51);
          alert(context, "CCTV", cctv.name);
        } catch (_) {
          print('ERROR LOADING MARKER DETAILS');
        }
        setState(() {
          _isLoading = false;
        });*/
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  List<MarkerModel> _getCctvList(BuildContext context) {
    List<MarkerModel> markerList = BlocProvider.of<AppBloc>(context).markerList;
    return markerList.where((marker) => marker.category.code == CategoryType.CCTV).toList();
  }

  void _handleClickScaleButton(String scale) async {
    final WebViewController controller = await _controller.future;
    controller.evaluateJavascript('schematicMap.setZoomLevel($scale);');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      //backgroundColor: Colors.blue,
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: Color(0xFF575757),
          /*image: DecorationImage(
            image: AssetImage('assets/images/login/bg_login.jpg'),
            fit: BoxFit.cover,
          ),*/
        ),
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: Column(
                children: <Widget>[
                  // พื้นที่ด้านบน maps (ปุ่ม home)
                  Flexible(
                    flex: 2,
                    child: Padding(
                        padding: EdgeInsets.only(
                          left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                          right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN) -
                              getPlatformSize(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // exat logo
                            Padding(
                              padding: EdgeInsets.only(
                                left: getPlatformSize(0.0),
                                right: getPlatformSize(0.0),
                                top: getPlatformSize(10.0),
                                bottom: 0.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Visibility(
                                    visible: false,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(getPlatformSize(0.0)),
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/login/exat_logo_white_no_text-w200.png'),
                                          width: getPlatformSize(24.0 * 20.0 / 17.6),
                                          height: getPlatformSize(24.0),
                                        ),
                                      ),
                                    ),
                                    /*child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(getPlatformSize(0.0)),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: getPlatformSize(3.0),
                                          right: getPlatformSize(3.0),
                                          top: getPlatformSize(2.0),
                                          bottom: getPlatformSize(3.0),
                                        ),
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/home/ic_menu.png'),
                                          width: getPlatformSize(22.0),
                                          height: getPlatformSize(20.0),
                                        ),
                                      ),
                                    ),
                                  ),*/
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(getPlatformSize(22.0)),
                                      ),
                                      child: Container(
                                        width: getPlatformSize(44.0),
                                        height: getPlatformSize(44.0),
                                        child: Center(
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/schematic_maps/ic_home.png'),
                                            width: getPlatformSize(20.69),
                                            height: getPlatformSize(17.19),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),

                  // WebView
                  Padding(
                    padding: EdgeInsets.only(
                      left: 0,
                      //getPlatformSize(Constants.LoginScreen.HORIZONTAL_MARGIN),
                      right: 0, //getPlatformSize(Constants.LoginScreen.HORIZONTAL_MARGIN),
                    ),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 4621.4 / 5134,
                        child: WebView(
                          initialUrl: 'http://163.47.9.26/demo/schematic_map_full.html?backend=0',
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (WebViewController webViewController) {
                            _controller.complete(webViewController);
                          },
                          // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                          // ignore: prefer_collection_literals
                          javascriptChannels: <JavascriptChannel>[
                            _cctvJavascriptChannel(context),
                          ].toSet(),
                          /*navigationDelegate: (NavigationRequest request) {
                          if (request.url.startsWith('https://www.youtube.com/')) {
                            print('blocking navigation to $request}');
                            return NavigationDecision.prevent;
                          }
                          print('allowing navigation to $request');
                          return NavigationDecision.navigate;
                        },*/
                          onPageStarted: (String url) {
                            print('Page started loading: $url');
                          },
                          onPageFinished: (String url) {
                            print('Page finished loading: $url');
                          },
                          gestureNavigationEnabled: true,
                        ),
                      ),
                    ),
                  ),

                  // พื้นที่ด้านล่าง maps (ปุ่มเครื่องมือ)
                  Flexible(
                    flex: 3,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              MapToolItem(
                                icon:
                                    AssetImage('assets/images/map_tools/ic_map_tool_location.png'),
                                iconWidth: getPlatformSize(21.0),
                                iconHeight: getPlatformSize(21.0),
                                marginTop: getPlatformSize(0.0),
                                isChecked: false,
                                showProgress: false,
                                onClick: () {
                                  alert(context, 'EXAT Traffic',
                                      'Under construction, coming soon :)');
                                },
                              ),
                              SizedBox(
                                width: getPlatformSize(15.0),
                              ),
                              MapToolItem(
                                icon: AssetImage('assets/images/schematic_maps/ic_zoom_in.png'),
                                iconWidth: getPlatformSize(18.52),
                                iconHeight: getPlatformSize(18.52),
                                marginTop: getPlatformSize(0.0),
                                isChecked: false,
                                showProgress: false,
                                onClick: () async {
                                  final WebViewController controller = await _controller.future;
                                  controller.evaluateJavascript('schematicMap.changeZoom(1);');
                                },
                              ),
                              SizedBox(
                                width: getPlatformSize(15.0),
                              ),
                              MapToolItem(
                                icon: AssetImage('assets/images/schematic_maps/ic_zoom_out.png'),
                                iconWidth: getPlatformSize(18.52),
                                iconHeight: getPlatformSize(18.52),
                                marginTop: getPlatformSize(0.0),
                                isChecked: false,
                                showProgress: false,
                                onClick: () async {
                                  final WebViewController controller = await _controller.future;
                                  controller.evaluateJavascript('schematicMap.changeZoom(-1);');
                                },
                              ),
                              SizedBox(
                                width: getPlatformSize(15.0),
                              ),
                              MapToolItem(
                                icon: AssetImage('assets/images/schematic_maps/ic_cctv.png'),
                                iconWidth: getPlatformSize(23.16),
                                iconHeight: getPlatformSize(19.19),
                                marginTop: getPlatformSize(0.0),
                                isChecked: _showCctv,
                                showProgress: false,
                                onClick: () async {
                                  final WebViewController controller = await _controller.future;

                                  String jsonCctvList = jsonEncode(_getCctvList(context));
                                  /*print('*********************************');
                                  print(jsonCctvList);
                                  print('*********************************');*/

                                  bool showCctv = !_showCctv;
                                  setState(() {
                                    _showCctv = showCctv;
                                  });

                                  if (showCctv) {
                                    controller.evaluateJavascript(
                                        'schematicMap.setCctvList($jsonCctvList);');
                                  }
                                  controller.evaluateJavascript(
                                      'schematicMap.setCctvVisible($showCctv);');
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: getPlatformSize(10.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ScaleButton(
                                  text: "X1",
                                  onClick: () {
                                    _handleClickScaleButton("1");
                                  }),
                              SizedBox(width: getPlatformSize(8.0)),
                              ScaleButton(
                                  text: "X2",
                                  onClick: () {
                                    _handleClickScaleButton("5");
                                  }),
                              SizedBox(width: getPlatformSize(8.0)),
                              ScaleButton(
                                  text: "X3",
                                  onClick: () {
                                    _handleClickScaleButton("10");
                                  }),
                              SizedBox(width: getPlatformSize(8.0)),
                              ScaleButton(
                                  text: "FIT",
                                  onClick: () {
                                    _handleClickScaleButton("1.3");
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: _isLoading ? MyProgressIndicator() : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class ScaleButton extends StatelessWidget {
  final String text;
  final Function onClick;

  ScaleButton({
    @required this.text,
    @required this.onClick,
  });

  static const double SIZE = 40.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getPlatformSize(SIZE),
      height: getPlatformSize(SIZE),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.26),
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (onClick != null) {
              onClick();
            }
          },
          //highlightColor: Constants.App.PRIMARY_COLOR,
          borderRadius: BorderRadius.all(
            Radius.circular(getPlatformSize(SIZE) / 2),
          ),
          child: Center(
            child: Text(
              text,
              style: getTextStyle(
                0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
