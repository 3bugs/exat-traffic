import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/components/list_item.dart';
import 'package:exattraffic/models/emergency_number_model.dart';

class EmergencyView extends StatelessWidget {
  EmergencyView({
    @required this.emergencyNumber,
    @required this.isFirstItem,
    @required this.isLastItem,
    this.isSos = false,
    @required this.onClick,
  });

  final EmergencyNumberModel emergencyNumber;
  final bool isFirstItem;
  final bool isLastItem;
  final bool isSos;
  final Function onClick;

  String _formatPhoneNumber(String number) {
    if (number == null) return "";

    String temp = number.trim().replaceAll("-", "");
    if (temp.length == 9 && temp.substring(0, 2) == "02") {
      return "${temp.substring(0, 2)}-${temp.substring(2, 5)}-${temp.substring(5)}";
    } else {
      return number.trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListItem(
      onClick: onClick,
      marginTop: getPlatformSize(isFirstItem ? 21.0 : 7.0),
      marginBottom: getPlatformSize(isLastItem ? 21.0 : 7.0),
      padding: EdgeInsets.only(
        left: getPlatformSize(16.0),
        right: getPlatformSize(16.0),
        top: getPlatformSize(18.0),
        bottom: getPlatformSize(18.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    return Text(
                      emergencyNumber.name,
                      style: getTextStyle(
                        language.lang,
                        color: isSos ? Constants.App.SOS_COLOR : Constants.App.ACCENT_COLOR,
                        isBold: true,
                        heightEn: 1.6,
                      ),
                    );
                  },
                ),
                isSos
                    ? SizedBox.shrink()
                    : Text(
                        _formatPhoneNumber(emergencyNumber.number),
                        style: GoogleFonts.kanit(
                          textStyle: TextStyle(
                            fontSize: getPlatformSize(20.0),
                            //fontWeight: FontWeight.bold,
                            height: 1.2,
                            //letterSpacing: 1.0,
                            color: Color(0xFFB2B2B2),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            width: getPlatformSize(43.0),
            height: getPlatformSize(43.0),
            child: Container(
              decoration: BoxDecoration(
                color: isSos ? Constants.App.SOS_COLOR : Constants.App.ACCENT_COLOR,
                borderRadius: BorderRadius.all(
                  Radius.circular(getPlatformSize(21.5)),
                ),
              ),
              child: Center(
                child: Image(
                  image: AssetImage(
                      'assets/images/emergency/ic_emergency_${isSos ? 'sos' : 'phone'}.png'),
                  width: getPlatformSize(isSos ? 25.35 : 19.31),
                  height: getPlatformSize(isSos ? 25.3 : 19.41),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
