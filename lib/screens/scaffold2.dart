import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/components/header.dart';
import 'package:exattraffic/components/search_box.dart';
import 'package:exattraffic/models/language_model.dart';

//https://medium.com/flutter-community/simple-ways-to-pass-to-and-share-data-with-widgets-pages-f8988534bd5b

class YourScaffold extends StatefulWidget {
  final List<String> titleList;
  final Widget child;
  final Function builder;
  final bool showSearch;
  final bool searchBoxAutoFocus;
  final String searchBoxHint;
  final Function onSearchTextChanged;

  YourScaffold({
    Key key,
    @required this.titleList,
    this.child,
    this.builder,
    this.showSearch = false,
    this.searchBoxAutoFocus = false,
    this.searchBoxHint = "ค้นหา",
    this.onSearchTextChanged,
  }) : super(key: key);

  @override
  YourScaffoldState createState() => YourScaffoldState();
}

class YourScaffoldState extends State<YourScaffold> {
  static const List<Color> BG_GRADIENT_COLORS = [
    Constants.App.HEADER_GRADIENT_COLOR_START,
    Constants.App.HEADER_GRADIENT_COLOR_END,
  ];
  static const List<double> BG_GRADIENT_STOPS = [0.0, 1.0];

  final GlobalKey _keyMainContainer = GlobalKey();
  final _textEditingController = TextEditingController();

  //double _mainContainerTop = 0; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  double _mainContainerHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()

  _afterLayout(_) {
    final RenderBox mainContainerRenderBox = _keyMainContainer.currentContext.findRenderObject();
    setState(() {
      //_mainContainerTop = mainContainerRenderBox.localToGlobal(Offset.zero).dy;
      _mainContainerHeight = mainContainerRenderBox.size.height;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _textEditingController.addListener(() {
      widget.onSearchTextChanged(_textEditingController.text);
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.titleList != null && widget.titleList.length >= 3);

    return wrapSystemUiOverlayStyle(
      child: Scaffold(
        resizeToAvoidBottomInset: false, // prevent keyboard from pushing layout up
        appBar: null,
        bottomNavigationBar: SafeArea(
          child: SizedBox.shrink(),
        ),
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
                    key: _keyMainContainer,
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

                        child: widget.builder != null
                            ? widget.builder(
                                context,
                                _mainContainerHeight -
                                    getPlatformSize(Constants.HomeScreen.MAPS_VERTICAL_POSITION),
                              )
                            : widget.child,
                        //child: widget.child,
                        /*child: InheritedDataProvider(
                          containerHeight: _mainContainerHeight,
                          child: widget.child,
                        ),*/
                      ),

                      // ช่อง search
                      Visibility(
                        visible: widget.showSearch,
                        child: SearchBox(
                          onClickCloseButton: () {
                            widget.onSearchTextChanged("");
                            _textEditingController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          child: Consumer<LanguageModel>(
                            builder: (context, language, child) {
                              return TextField(
                                autofocus: widget.searchBoxAutoFocus,
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                    top: getPlatformSize(4.0),
                                    bottom: getPlatformSize(4.0),
                                  ),
                                  border: InputBorder.none,
                                  hintText: widget.searchBoxHint, //_searchHintList[language.lang],
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

class InheritedDataProvider extends InheritedWidget {
  final double containerHeight;

  InheritedDataProvider({
    Widget child,
    this.containerHeight,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedDataProvider oldWidget) =>
      containerHeight != oldWidget.containerHeight;

  static InheritedDataProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedDataProvider>();
}
