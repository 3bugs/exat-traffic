import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/components/list_item.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/components/my_cached_image.dart';
import 'package:exattraffic/models/category_model.dart';

class SearchServiceView extends StatelessWidget {
  SearchServiceView({
    @required this.marker,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.onClick,
  });

  final MarkerModel marker;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    return Text(
                      marker.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        language.lang,
                        color: Constants.App.ACCENT_COLOR,
                        isBold: true,
                        heightEn: 1.6,
                      ),
                    );
                  },
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: getPlatformSize(20.0),
                      height: getPlatformSize(20.0 * 348 / 267),
                      child: MyCachedImage(
                        imageUrl: marker.category.markerIconUrl,
                        progressIndicatorSize: ProgressIndicatorSize.small,
                        boxFit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: getPlatformSize(8.0)),
                    Consumer<LanguageModel>(
                      builder: (context, language, child) {
                        return Text(
                          marker.category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            language.lang,
                            color: Constants.Font.DIM_COLOR,
                            heightEn: 1.6,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          _getThumbImage(),

          /*SizedBox(
            width: getPlatformSize(25.0),
            height: getPlatformSize(25.0 * 348 / 267),
            child: MyCachedImage(
              imageUrl: marker.category.markerIconUrl,
              progressIndicatorSize: ProgressIndicatorSize.small,
              boxFit: BoxFit.contain,
            ),
          ),
          SizedBox(
            width: getPlatformSize(14.0),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    String name;
                    switch (language.lang) {
                      case 0:
                        name = marker.name;
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
                        heightEn: 1.6,
                      ),
                    );
                  },
                ),
                Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    String description;
                    switch (language.lang) {
                      case 0:
                        description = marker.category.name;
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
                        heightEn: 1.6,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: getPlatformSize(43.0),
            height: getPlatformSize(43.0),
            child: Container(
              decoration: BoxDecoration(
                color: Constants.App.ACCENT_COLOR,
                borderRadius: BorderRadius.all(
                  Radius.circular(getPlatformSize(21.5)),
                ),
              ),
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/favorite/ic_favorite_arrow.png'),
                  width: getPlatformSize(17.0),
                  height: getPlatformSize(17.0),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _getThumbImage() {
    if (marker.category.code == CategoryType.CCTV && marker.streamMobile != null) {
      return ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(getPlatformSize(9.0)),
          ),
          child: SizedBox(
            width: getPlatformSize(75.0),
            height: getPlatformSize(58.0),
            child: Stack(
              children: <Widget>[
                SizedBox(
                  width: getPlatformSize(75.0),
                  height: getPlatformSize(58.0),
                  child: Image(
                    image: AssetImage('assets/images/cctv_details/video_preview_mock.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Image(
                    image: AssetImage('assets/images/cctv_details/ic_playback.png'),
                    width: getPlatformSize(30.0),
                    height: getPlatformSize(30.0),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ));
    } else if (marker.godImageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(getPlatformSize(9.0)),
        ),
        child: SizedBox(
          width: getPlatformSize(75.0),
          height: getPlatformSize(58.0),
          child: MyCachedImage(
            imageUrl: marker.godImageUrl,
            progressIndicatorSize: ProgressIndicatorSize.small,
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
