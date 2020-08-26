import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/components/my_button.dart';
import 'package:exattraffic/constants.dart' as Constants;

class ErrorView extends StatelessWidget {
  final String title;
  final String text;
  final String buttonText;
  final bool withBackground;
  final Color backgroundColor;
  final double backgroundOpacity;
  final Function onClick;

  ErrorView({
    @required this.title,
    @required this.text,
    @required this.buttonText,
    this.withBackground = true,
    this.backgroundColor = Colors.white,
    this.backgroundOpacity = 0.92,
    @required this.onClick,
  });

  Widget _content() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          this.title != null && this.title.trim().isNotEmpty
              ? Text(
                  this.title,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    0,
                    isBold: true,
                    sizeTh: Constants.Font.BIGGER_SIZE_TH,
                    sizeEn: Constants.Font.BIGGER_SIZE_EN,
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(
            height: getPlatformSize(this.title != null && this.title.trim().isNotEmpty ? 8.0 : 0.0),
          ),
          Text(
            this.text,
            textAlign: TextAlign.center,
            style: getTextStyle(0),
          ),
          SizedBox(
            height: getPlatformSize(24.0),
          ),
          MyButton(
            text: this.buttonText,
            onClick: this.onClick,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.withBackground
        ? Container(
            padding: EdgeInsets.symmetric(
              vertical: getPlatformSize(24.0),
              horizontal: getPlatformSize(16.0),
            ),
            decoration: BoxDecoration(
              color: this.backgroundColor.withOpacity(this.backgroundOpacity),
              borderRadius: BorderRadius.all(Radius.circular(getPlatformSize(4.0))),
            ),
            child: _content(),
          )
        : _content();
  }
}
