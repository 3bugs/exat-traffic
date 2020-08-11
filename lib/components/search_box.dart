import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

class SearchBox extends StatefulWidget {
  final Function onClickBox;
  final Function onClickCloseButton;
  final Widget child;

  SearchBox({
    this.onClickBox,
    this.onClickCloseButton,
    @required this.child,
  });

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      /*transform: Matrix4.translationValues(
          0.0,
          getPlatformSize(-24.0),
          0.0,
        ),*/
      margin: EdgeInsets.only(
        top: getPlatformSize(Constants.HomeScreen.SEARCH_BOX_VERTICAL_POSITION),
        left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
        right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
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
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onClickBox,
          borderRadius: BorderRadius.all(
            Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: getPlatformSize(6.0),
              bottom: getPlatformSize(6.0),
              left: getPlatformSize(20.0),
              right: getPlatformSize(12.0),
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
                    child: widget.child,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onClickCloseButton,
                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    child: Container(
                      width: getPlatformSize(36.0),
                      height: getPlatformSize(36.0),
                      //padding: EdgeInsets.all(getPlatformSize(15.0)),
                      child: Center(
                        child: Image(
                          image: AssetImage('assets/images/home/ic_close_search.png'),
                          width: getPlatformSize(24.0),
                          height: getPlatformSize(24.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
