import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/home/home.dart';

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

  JavascriptChannel _cctvJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'CCTV',
      onMessageReceived: (JavascriptMessage jsMessage) {
        print(jsMessage.message);
        alert(context, "CCTV", jsMessage.message);
      },
    );
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
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // พื้นที่ด้านบน maps (ปุ่ม home)
              Flexible(
                flex: 1,
                child: Padding(
                    padding: EdgeInsets.only(
                      left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                      right:
                          getPlatformSize(Constants.App.HORIZONTAL_MARGIN) - getPlatformSize(10.0),
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
                                        image:
                                            AssetImage('assets/images/schematic_maps/ic_home.png'),
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
                      initialUrl: 'http://163.47.9.26/demo/schematic_map_full.html',
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
                flex: 2,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MapToolItem(
                        icon: AssetImage('assets/images/map_tools/ic_map_tool_location.png'),
                        iconWidth: getPlatformSize(21.0),
                        iconHeight: getPlatformSize(21.0),
                        marginTop: getPlatformSize(0.0),
                        isChecked: false,
                        showProgress: false,
                        onClick: () {
                          alert(context, 'EXAT Traffic', 'Under construction, coming soon :)');
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
                          bool showCctv = !_showCctv;
                          setState(() {
                            _showCctv = showCctv;
                          });
                          final WebViewController controller = await _controller.future;
                          controller.evaluateJavascript('schematicMap.setCctvVisible($showCctv);');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
