import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/components/tool_item.dart';
import 'package:exattraffic/models/marker_categories/uturn_model.dart';
import 'package:exattraffic/components/my_cached_image.dart';

class UTurnDetails extends StatelessWidget {
  UTurnDetails(this._uTurnModel);

  final UTurnModel _uTurnModel;

  @override
  Widget build(BuildContext context) {
    return wrapSystemUiOverlayStyle(child: UTurnDetailsMain(_uTurnModel));
  }
}

class UTurnDetailsMain extends StatefulWidget {
  UTurnDetailsMain(this._uTurnModel);

  final UTurnModel _uTurnModel;

  @override
  _UTurnDetailsMainState createState() => _UTurnDetailsMainState();
}

class _UTurnDetailsMainState extends State<UTurnDetailsMain> {
  void _handleClickTool(int toolItemIndex) {
    switch (toolItemIndex) {
      case 0: // phone
        break;
      case 1: // directions
        break;
    }
  }

  void _handleClickClose(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getPlatformSize(0.0),
              //getPlatformSize(Constants.CctvPlayerScreen.HORIZONTAL_MARGIN),
              vertical: getPlatformSize(0.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: getPlatformSize(10.0),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        hoverColor: Color(0xFF999999),
                        splashColor: Color(0xFF999999),
                        highlightColor: Color(0xFF999999),
                        focusColor: Color(0xFF999999),
                        onTap: () => _handleClickClose(context),
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        child: Container(
                          width: getPlatformSize(36.0),
                          height: getPlatformSize(36.0),
                          //padding: EdgeInsets.all(getPlatformSize(15.0)),
                          child: Center(
                            child: Image(
                              image: AssetImage('assets/images/cctv_details/ic_close_cctv.png'),
                              width: getPlatformSize(13.5),
                              height: getPlatformSize(13.5),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getPlatformSize(16.0),
                ),
                Center(
                  child: Consumer<LanguageModel>(
                    builder: (context, language, child) {
                      return Text(
                        widget._uTurnModel.name,
                        style: getTextStyle(
                          language.lang,
                          sizeTh: Constants.Font.BIGGER_SIZE_TH,
                          sizeEn: Constants.Font.BIGGER_SIZE_EN,
                          color: Colors.white,
                          isBold: true,
                          //heightEn: 1.5 / 0.9,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: getPlatformSize(25.0),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: getPlatformSize(Constants.CctvPlayerScreen.HORIZONTAL_MARGIN),
                    vertical: getPlatformSize(0.0),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(getPlatformSize(10.0)),
                      ),
                      child: MyCachedImage(
                        imageUrl: widget._uTurnModel.imageUrl,
                        progressIndicatorSize: ProgressIndicatorSize.large,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getPlatformSize(28.0),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getPlatformSize(Constants.CctvPlayerScreen.HORIZONTAL_MARGIN),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      false
                          ? ToolItem(
                              'โทรศัพท์',
                              AssetImage('assets/images/police_station_details/ic_phone.png'),
                              getPlatformSize(16.0),
                              getPlatformSize(24.0),
                              false,
                              () => this._handleClickTool(0),
                            )
                          : SizedBox.shrink(),
                      /*ToolItem(
                        'เส้นทาง',
                        AssetImage('assets/images/cctv_details/ic_route.png'),
                        getPlatformSize(27.06),
                        getPlatformSize(35.21),
                        false,
                        () => this._handleClickTool(1),
                      ),*/
                    ],
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
