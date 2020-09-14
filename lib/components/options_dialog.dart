import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';

class OptionsDialog extends StatelessWidget {
  final String title;
  final List<OptionModel> optionList;
  final EdgeInsets itemPadding;
  final Function onClickClose;

  OptionsDialog({this.title, @required this.optionList, this.itemPadding, this.onClickClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
        right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
      ),
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
          Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (this.title != null)
            Consumer<LanguageModel>(
              builder: (context, language, child) {
                return Container(
                  //padding: this.itemPadding,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: getPlatformSize(6.0),
                      bottom: getPlatformSize(2.0),
                      left: getPlatformSize(0.0),
                      right: getPlatformSize(0.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: getPlatformSize(42.0),
                          height: getPlatformSize(42.0),
                        ),
                        Text(
                          this.title,
                          style:
                              getTextStyle(language.lang, color: Color(0xFF454F63), isBold: true),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onClickClose,
                            borderRadius: BorderRadius.all(Radius.circular(21.0)),
                            child: Container(
                              width: getPlatformSize(42.0),
                              height: getPlatformSize(42.0),
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
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          //if (this.title != null) _buildSeparator(),
          Column(
            children: optionList
                .asMap()
                .entries
                .map<Widget>(
                  (entry) => OptionItem(
                    option: entry.value,
                    padding: this.itemPadding,
                    isFirstItem: entry.key == 0 && this.title == null,
                    isLastItem: entry.key == optionList.length - 1,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class OptionModel {
  final String text;
  final Function onClick;
  final Color bulletColor;

  OptionModel({
    @required this.text,
    @required this.onClick,
    @required this.bulletColor,
  });
}

class OptionItem extends StatelessWidget {
  final OptionModel option;
  final EdgeInsets padding;
  final bool isFirstItem;
  final bool isLastItem;

  OptionItem({
    @required this.option,
    @required this.padding,
    this.isFirstItem = false,
    this.isLastItem = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (!this.isFirstItem) _buildSeparator(),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: this.option.onClick,
            borderRadius: this.isFirstItem
                ? BorderRadius.only(
                    topLeft: Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                    topRight: Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                  )
                : this.isLastItem
                    ? BorderRadius.only(
                        bottomLeft:
                            Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                        bottomRight:
                            Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                      )
                    : BorderRadius.zero,
            child: Padding(
              padding: this.padding ??
                  EdgeInsets.symmetric(
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
                      color: this.option.bulletColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(getPlatformSize(3.0)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Consumer<LanguageModel>(
                      builder: (context, language, child) {
                        return Text(
                          this.option.text,
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
    );
  }
}

Widget _buildSeparator() {
  return Container(
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
  );
}
