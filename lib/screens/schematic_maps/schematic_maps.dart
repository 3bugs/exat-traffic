import 'package:exattraffic/bloc_old/bloc_provider.dart';
import 'package:exattraffic/bloc_old/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

// iOS setup
// Opt-in to the embedded views preview by adding a boolean property to
// the app's Info.plist file with the key io.flutter.embedded_views_preview and the value YES.

class SchematicMaps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: LoginBloc(),
      child: wrapSystemUiOverlayStyle(
        child: SchematicMapsMain(),
      ),
    );
  }
}

class SchematicMapsMain extends StatefulWidget {
  @override
  _SchematicMapsMainState createState() => _SchematicMapsMainState();
}

class _SchematicMapsMainState extends State<SchematicMapsMain> {
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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 0, //getPlatformSize(Constants.LoginScreen.HORIZONTAL_MARGIN),
              right: 0, //getPlatformSize(Constants.LoginScreen.HORIZONTAL_MARGIN),
            ),
            child: WebView(
              initialUrl: 'http://163.47.9.26/demo/schematic_map_full.html',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                //_controller.complete(webViewController);
              },
              // TODO(iskakaushik): Remove this when collection literals makes it to stable.
              // ignore: prefer_collection_literals
              javascriptChannels: <JavascriptChannel>[
                //_toasterJavascriptChannel(context),
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
    );
  }
}
