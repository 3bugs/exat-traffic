import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/incident_model.dart';
import 'package:exattraffic/components/list_item.dart';

import '../incident_detail.dart';

class IncidentView extends StatelessWidget {
  IncidentView({
    @required this.incident,
    @required this.isFirstItem,
    @required this.isLastItem,
    this.id,
  });

  final IncidentModel incident;
  final bool isFirstItem;
  final bool isLastItem;
  int id;

  @override
  Widget build(BuildContext context) {
    return ListItem(
        marginTop: getPlatformSize(isFirstItem ? 21.0 : 7.0),
        marginBottom: getPlatformSize(isLastItem ? 21.0 : 7.0),
        padding: EdgeInsets.all(getPlatformSize(12.0)),
        child: InkWell(
          onTap: (){
//            print(id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IncidentDetailPage(id: id,),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(getPlatformSize(9.0)),
                ),
                child: Image(
                  image: incident.image,
                  width: getPlatformSize(97.0),
                  height: getPlatformSize(69.0),
                  fit: BoxFit.cover,
                ),
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
                        String name;
                        switch (language.lang) {
                          case 0:
                            name = incident.name;
                            break;
                          case 1:
                            name = 'Lorem ipsum dolor sit amet';
                            break;
                          case 2:
                            name = '高速公路 高速公路';
                            break;
                        }
                        return Text(
                          name,
                          style: getTextStyle(
                            language.lang,
                            color: Constants.App.ACCENT_COLOR,
                            isBold: true,
                            heightEn: 1.5,
                          ),
                        );
                      },
                    ),
                    Consumer<LanguageModel>(
                      builder: (context, language, child) {
                        String description;
                        switch (language.lang) {
                          case 0:
                            description = incident.description;
                            break;
                          case 1:
                            description =
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
                            break;
                          case 2:
                            description =
                                '高速公路 高速公路 高速公路 高速公路 高速公路 高速公路 高速公路 高速公路 高速公路 高速公路 高速公路 高速公路 高速公路 高速公路 高速公路 高速公路 高速公路';
                            break;
                        }
                        return Text(
                          description,
                          style: getTextStyle(
                            language.lang,
                            color: Constants.Font.DIM_COLOR,
                            heightEn: 1.6,
                            sizeTh: Constants.Font.SMALLER_SIZE_TH,
                            sizeEn: Constants.Font.SMALLER_SIZE_EN,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                    Consumer<LanguageModel>(builder: (context, language, child) {
                      return SizedBox(
                        height: getPlatformSize(language.lang == 0 ? 3.0 : 6.0),
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
                                1, // ใช้ system default font เสมอ
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
        ),
      );
  }
}
