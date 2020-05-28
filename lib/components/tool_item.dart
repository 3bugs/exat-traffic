import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';

class ToolItem extends StatefulWidget {
  const ToolItem(
    this._text,
    this._icon,
    this._iconWidth,
    this._iconHeight,
    this._checked,
    this._onClick,
  );

  final String _text;
  final AssetImage _icon;
  final double _iconWidth;
  final double _iconHeight;
  final bool _checked;
  final Function _onClick;

  @override
  _ToolItemState createState() => _ToolItemState();
}

class _ToolItemState extends State<ToolItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          hoverColor: Constants.App.PRIMARY_COLOR.withOpacity(0.2),
          splashColor: Constants.App.PRIMARY_COLOR.withOpacity(0.2),
          highlightColor: Constants.App.PRIMARY_COLOR.withOpacity(0.2),
          focusColor: Constants.App.PRIMARY_COLOR.withOpacity(0.2),
          onTap: widget._onClick,
          //borderRadius: BorderRadius.all(Radius.circular(18.0)),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: getPlatformSize(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: getPlatformSize(56.0),
                  height: getPlatformSize(56.0),
                  margin: EdgeInsets.only(
                    bottom: getPlatformSize(16.0),
                  ),
                  decoration: BoxDecoration(
                    color: widget._checked
                        ? Constants.App.PRIMARY_COLOR
                        : Colors.white.withOpacity(0.53),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        getPlatformSize(28.0),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Image(
                      image: widget._icon,
                      width: widget._iconWidth,
                      height: widget._iconHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    String name;
                    switch (language.lang) {
                      case 0:
                        name = widget._text;
                        break;
                      case 1:
                        name = 'Expressway';
                        break;
                      case 2:
                        name = '高速公路';
                        break;
                    }
                    return Text(
                      name,
                      style: getTextStyle(
                        language.lang,
                        color: widget._checked ? Colors.white : Color(0xFFB8B8B8),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
