import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/components/header.dart';
import 'package:exattraffic/components/search_box.dart';
import 'package:exattraffic/models/language_model.dart';

class YourScaffold extends StatefulWidget {
  final List<String> titleList;
  final Widget child;
  final bool showSearch;
  final Function onClickSearchCloseButton;

  YourScaffold({
    @required this.titleList,
    @required this.child,
    this.showSearch = false,
    this.onClickSearchCloseButton,
  });

  @override
  _YourScaffoldState createState() => _YourScaffoldState();
}

class _YourScaffoldState extends State<YourScaffold> {
  static const List<Color> BG_GRADIENT_COLORS = [
    Constants.App.HEADER_GRADIENT_COLOR_START,
    Constants.App.HEADER_GRADIENT_COLOR_END,
  ];
  static const List<double> BG_GRADIENT_STOPS = [0.0, 1.0];

  @override
  Widget build(BuildContext context) {
    assert(widget.titleList != null && widget.titleList.length >= 3);

    return wrapSystemUiOverlayStyle(
      child: Scaffold(
        appBar: null,
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
                Header(
                  titleList: widget.titleList,
                  showDate: false,
                  leftIcon: HeaderIcon(
                    image: AssetImage('assets/images/home/ic_back_white.png'),
                    onClick: () {
                      Navigator.pop(context);
                    },
                  ),
                  rightIcon: null,
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
                          color: Colors.white,
                        ),
                        // main container
                        child: widget.child,
                      ),

                      // ช่อง search
                      Visibility(
                        visible: widget.showSearch,
                        child: SearchBox(
                          onClickCloseButton: widget.onClickSearchCloseButton,
                          child: Consumer<LanguageModel>(
                            builder: (context, language, child) {
                              return TextField(
                                onChanged: null,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                    top: getPlatformSize(4.0),
                                    bottom: getPlatformSize(4.0),
                                  ),
                                  border: InputBorder.none,
                                  hintText: "ค้นหา", //_searchHintList[language.lang],
                                ),
                                style: getTextStyle(language.lang),
                              );
                            },
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
  }
}
