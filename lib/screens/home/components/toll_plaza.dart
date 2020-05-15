import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/toll_plaza.dart';

class TollPlazaView extends StatelessWidget {
  TollPlazaView({
    @required this.tollPlaza,
    @required this.isFirstItem,
    @required this.isLastItem,
  });

  final TollPlaza tollPlaza;
  final bool isFirstItem;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: getPlatformSize(14.0),
            right: getPlatformSize(14.0),
            top: getPlatformSize(isFirstItem ? 7.0 : 7.0),
            bottom: getPlatformSize(isLastItem ? 21.0 : 7.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x11808080),
                  blurRadius: getPlatformSize(6.0),
                  spreadRadius: getPlatformSize(2.0),
                  offset: Offset(
                    getPlatformSize(2.0), // move right
                    getPlatformSize(2.0), // move down
                  ),
                ),
              ],
              color: Color(0xFFF4F4F4),
              border: Border.all(
                width: getPlatformSize(1.0),
                color: Color(0xFFE8E8E8),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.all(
                  Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    left: getPlatformSize(10.0),
                    right: getPlatformSize(10.0),
                    top: getPlatformSize(10.0),
                    bottom: getPlatformSize(10.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: getPlatformSize(4.0),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: getPlatformSize(4.0),
                          right: getPlatformSize(2.0),
                          top: getPlatformSize(0.0),
                          bottom: getPlatformSize(4.0),
                        ),
                        child: Image(
                          image: tollPlaza.isEntrance
                              ? AssetImage('assets/images/home/ic_arrow_green_up.png')
                              : AssetImage('assets/images/home/ic_arrow_red_up.png'),
                          width: getPlatformSize(15.6),
                          height: getPlatformSize(26.7),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: getPlatformSize(2.0),
                          right: getPlatformSize(4.0),
                          top: getPlatformSize(4.0),
                          bottom: getPlatformSize(0.0),
                        ),
                        child: Image(
                          image: tollPlaza.isExit
                              ? AssetImage('assets/images/home/ic_arrow_green_down.png')
                              : AssetImage('assets/images/home/ic_arrow_red_down.png'),
                          width: getPlatformSize(15.6),
                          height: getPlatformSize(26.7),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: getPlatformSize(30.0),
                          ),
                          child: Text(
                            tollPlaza.name,
                            style: TextStyle(
                              fontSize: getPlatformSize(Constants.Font.DEFAULT_SIZE),
                              color: Constants.Font.DEFAULT_COLOR,
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(getPlatformSize(9.0)),
                        ),
                        child: Image(
                          image: tollPlaza.image,
                          width: getPlatformSize(100.0),
                          height: getPlatformSize(65.0),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}