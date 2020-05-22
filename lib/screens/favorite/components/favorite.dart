import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:exattraffic/models/language.dart';
import 'package:exattraffic/models/favorite.dart';
import 'package:exattraffic/components/list_item.dart';

class FavoriteView extends StatelessWidget {
  FavoriteView({
    @required this.favorite,
    @required this.isFirstItem,
    @required this.isLastItem,
  });

  final FavoriteModel favorite;
  final bool isFirstItem;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      marginTop: getPlatformSize(isFirstItem ? 42.0 : 7.0),
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
          Image(
            image: AssetImage('assets/images/favorite/ic_favorite_marker.png'),
            width: getPlatformSize(26.0),
            height: getPlatformSize(26.2),
            fit: BoxFit.contain,
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
                        name = favorite.name;
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
                        description = favorite.description;
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
                        color: Color(0xFFB2B2B2),
                        heightEn: 1.6,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Image(
            image: AssetImage('assets/images/favorite/ic_favorite_next.png'),
            width: getPlatformSize(43.0),
            height: getPlatformSize(43.0),
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
