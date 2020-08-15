import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/components/list_item.dart';
import 'package:exattraffic/components/my_cached_image.dart';
import 'package:exattraffic/services/google_maps_services.dart';

class SearchPlaceView extends StatelessWidget {
  SearchPlaceView({
    @required this.searchResult,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.onClick,
  });

  final SearchResultModel searchResult;
  final bool isFirstItem;
  final bool isLastItem;
  final Function onClick;

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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: getPlatformSize(20.0),
                      height: getPlatformSize(20.0 * 348 / 267),
                      child: MyCachedImage(
                        imageUrl: searchResult.icon,
                        progressIndicatorSize: ProgressIndicatorSize.small,
                        boxFit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: getPlatformSize(8.0)),
                    Consumer<LanguageModel>(
                      builder: (context, language, child) {
                        String name;
                        switch (language.lang) {
                          case 0:
                            name = searchResult.placeDetails.name;
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
                            color: Constants.App.ACCENT_COLOR,
                            isBold: true,
                            //heightEn: 1.6,
                          ),
                          /*maxLines: 1,
                          overflow: TextOverflow.ellipsis,*/
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: getPlatformSize(4.0),
                ),
                Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    String description;
                    switch (language.lang) {
                      case 0:
                        description = searchResult.placeDetails.formattedAddress;
                        break;
                      case 1:
                        description = 'Expressway';
                        break;
                      case 2:
                        description = '高速公路';
                        break;
                    }
                    return Text(
                      description,
                      style: getTextStyle(
                        language.lang,
                        color: Constants.Font.DIM_COLOR,
                        sizeTh: Constants.Font.SMALLER_SIZE_TH,
                        sizeEn: Constants.Font.SMALLER_SIZE_EN,
                        //heightEn: 1.6,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}