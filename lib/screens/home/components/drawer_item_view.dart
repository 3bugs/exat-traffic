import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/drawer_item_model.dart';

class DrawerItemView extends StatelessWidget {
  DrawerItemView({
    @required this.drawerItemModel,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.paddingLeft,
  });

  final double ITEM_HEIGHT = 53.0;
  final DrawerItemModel drawerItemModel;
  final bool isFirstItem;
  final bool isLastItem;
  final double paddingLeft;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Color(0xFF01345F),
          highlightColor: Color(0xFF01345F),
          focusColor: Color(0xFF01345F),
          hoverColor: Color(0xFF01345F),
          onTap: () => drawerItemModel.onClick(context),
          child: Container(
            height: getPlatformSize(ITEM_HEIGHT),
            margin: EdgeInsets.only(
              top: isFirstItem ? getPlatformSize(12.0) : 0.0,
              bottom: isLastItem ? getPlatformSize(12.0) : 0.0,
            ),
            padding: EdgeInsets.only(
              left: getPlatformSize(paddingLeft),
              right: getPlatformSize(16.0),
              //top: getPlatformSize(12.0),
              //bottom: getPlatformSize(12.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: drawerItemModel.icon,
                  width: getPlatformSize(15.0),
                  height: getPlatformSize(15.0),
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  width: getPlatformSize(16.0),
                ),
                Expanded(
                  child: Consumer<LanguageModel>(
                    builder: (context, language, child) {
                      String name;
                      switch (language.lang) {
                        case 0:
                          name = drawerItemModel.text;
                          break;
                        case 1:
                          name = 'About Us';
                          break;
                        case 2:
                          name = '关于我们';
                          break;
                      }
                      return Text(
                        name,
                        style: getTextStyle(
                          language.lang,
                          sizeTh: 26.0,
                          sizeEn: 18.0,
                          color: Colors.white,
                          isBold: true,
                          //heightEn: 1.5,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
