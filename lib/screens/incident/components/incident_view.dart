import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/incident_model.dart';
import 'package:exattraffic/components/list_item.dart';
import 'package:exattraffic/screens/incident/incident_detail.dart';
import 'package:exattraffic/components/my_cached_image.dart';

class IncidentView extends StatelessWidget {
  IncidentView({
    @required this.incident,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.id,
  });

  final IncidentModel incident;
  final bool isFirstItem;
  final bool isLastItem;
  final int id;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      onClick: () {
        //print(id);
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, anim1, anim2) => IncidentDetailPage(
              id: id,
            ),
          ),
        );
      },
      marginTop: getPlatformSize(isFirstItem ? 21.0 : 7.0),
      marginBottom: getPlatformSize(isLastItem ? 21.0 : 7.0),
      padding: EdgeInsets.all(getPlatformSize(12.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(getPlatformSize(9.0)),
            ),

            child: SizedBox(
              width: getPlatformSize(97.0),
              height: getPlatformSize(69.0),
              child: MyCachedImage(
                imageUrl: incident.imageUrl,
                progressIndicatorSize: ProgressIndicatorSize.small,
              ),
            ),
            
            /*child: Image(
              image: incident.image,
              width: getPlatformSize(97.0),
              height: getPlatformSize(69.0),
              fit: BoxFit.cover,
            ),*/
          ),
          SizedBox(
            width: getPlatformSize(10.0),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    return Text(
                      incident.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        language.lang,
                        color: Constants.App.ACCENT_COLOR,
                        isBold: true,
                        heightEn: 1.5 / 0.9,
                      ),
                    );
                  },
                ),
                Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    return Text(
                      incident.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        language.lang,
                        color: Constants.Font.DIM_COLOR,
                        heightEn: 1.6 / 0.9,
                        sizeTh: Constants.Font.SMALLER_SIZE_TH,
                        sizeEn: Constants.Font.SMALLER_SIZE_EN,
                      ),
                    );
                  },
                ),
                Consumer<LanguageModel>(builder: (context, language, child) {
                  return SizedBox(
                    height: getPlatformSize(language.lang == LanguageName.thai ? 3.0 : 6.0),
                  );
                }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: getPlatformSize(4.0),
                    ),
                    Image(
                      image: AssetImage('assets/images/incident/ic_date.png'),
                      width: getPlatformSize(9.2),
                      height: getPlatformSize(8.17),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      width: getPlatformSize(4.0),
                    ),
                    Consumer<LanguageModel>(
                      builder: (context, language, child) {
                        return Text(
                          incident.date,
                          style: getTextStyle(
                            LanguageName.english, // ใช้ system default font เสมอ
                            color: Color(0xFFC0C0C0),
                            sizeEn: Constants.Font.LIST_DATE_SIZE,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
