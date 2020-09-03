import 'package:flutter/material.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/drawer_item_model.dart';
import 'package:exattraffic/screens/FAQ/FAQ_page.dart';
import 'package:exattraffic/screens/about/about_page.dart';
//import 'package:exattraffic/screens/consent/consent_page.dart';
import 'package:exattraffic/screens/help/help_page.dart';
import 'package:exattraffic/screens/home/components/drawer_item_view.dart';
import 'package:exattraffic/screens/questionnaire/questionnaire_page.dart';
import 'package:exattraffic/screens/widget/widget.dart';
import 'package:exattraffic/app/app_bloc.dart';
import 'package:exattraffic/screens/settings/settings.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/locale_text.dart';

class MyDrawer extends StatelessWidget {
  // ignore: non_constant_identifier_names
  static final double MARGIN_LEFT = getPlatformSize(34.0);

  MyDrawer();

  final List<DrawerItemModel> _drawerItemList = [
    DrawerItemModel(
      text: LocaleText(thai: "เกี่ยวกับเรา", english: "About Us", chinese: "关于我们"),
      icon: AssetImage('assets/images/drawer/ic_about_us.png'),
      onClick: (BuildContext context) {
        // ปิด drawer
        Navigator.pop(context);
        // เปิดหน้า About Us
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutPage(),
          ),
        );
      },
    ),
    DrawerItemModel(
      text: LocaleText(thai: "แบบสอบถาม", english: "Questionnaire", chinese: "问卷调查"),
      icon: AssetImage('assets/images/drawer/ic_questionnaire.png'),
      onClick: (BuildContext context) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionnairePage(),
          ),
        );
      },
    ),
    DrawerItemModel(
      text: LocaleText(thai: "ช่วยเหลือ", english: "Help", chinese: "救命"),
      icon: AssetImage('assets/images/drawer/ic_help.png'),
      onClick: (BuildContext context) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HelpPage(),
          ),
        );
      },
    ),
    DrawerItemModel(
      text: LocaleText(thai: "คำถามที่พบบ่อย", english: "FAQ", chinese: "经常问的问题"),
      icon: AssetImage('assets/images/drawer/ic_faq.png'),
      onClick: (BuildContext context) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FAQPage(),
          ),
        );
      },
    ),
    DrawerItemModel(
      text: LocaleText(thai: "วิดเจ็ต", english: "Widget", chinese: "小部件"),
      icon: AssetImage('assets/images/drawer/ic_widget.png'),
      onClick: (BuildContext context) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WidgetSetting(),
          ),
        );
      },
    ),
    DrawerItemModel(
      text: LocaleText(thai: "การตั้งค่า", english: "Settings", chinese: "设定值"),
      icon: AssetImage('assets/images/drawer/ic_settings.png'),
      onClick: (BuildContext context) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Settings(),
          ),
        ).then((isLanguageChanged) {

        });
      },
    ),

    /*DrawerItemModel(
      text: 'ข้อกำหนดและเงื่อนไข',
      icon: AssetImage(''),
      onClick: (BuildContext context) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConsentPage(),
          ),
        );
      },
    ),*/
    /*DrawerItemModel(
      text: 'ออกจากระบบ',
      icon: AssetImage('assets/images/drawer/ic_logout.png'),
      onClick: (BuildContext context) {
        Navigator.pop(context);
      },
    ),*/
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2D4F80),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Container(
                  //height: mainContainerTop,
                  padding: EdgeInsets.only(
                    left: getPlatformSize(MARGIN_LEFT),
                    right: getPlatformSize(16.0),
                    top: getPlatformSize(25.0),
                    bottom: getPlatformSize(25.0),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF01345F),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(getPlatformSize(12.0)),
                              ),
                              child: Image(
                                image: AssetImage('assets/images/drawer/ic_launcher.png'),
                                width: getPlatformSize(64.0),
                                height: getPlatformSize(64.0),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                hoverColor: Color(0xFF2D4F80),
                                splashColor: Color(0xFF2D4F80),
                                highlightColor: Color(0xFF2D4F80),
                                focusColor: Color(0xFF2D4F80),
                                onTap: () => Navigator.pop(context),
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                child: Container(
                                  width: getPlatformSize(40.0),
                                  height: getPlatformSize(40.0),
                                  //padding: EdgeInsets.all(getPlatformSize(15.0)),
                                  child: Center(
                                    child: Image(
                                      image: AssetImage('assets/images/drawer/ic_close_drawer.png'),
                                      width: getPlatformSize(18.19),
                                      height: getPlatformSize(18.19),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getPlatformSize(15.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'EXAT Traffic',
                              //'Promlert Lovichit',
                              style: getTextStyle(
                                LanguageName.english,
                                sizeEn: Constants.Font.BIGGEST_SIZE_EN,
                                color: Colors.white,
                              ),
                            ),
                            /*Image(
                              image: AssetImage('assets/images/drawer/ic_logout.png'),
                              width: getPlatformSize(14.19),
                              height: getPlatformSize(14.51),
                              fit: BoxFit.contain,
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: getPlatformSize(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Color(0xFF665EFF),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Color(0xFF5773FF),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Color(0xFF3497FD),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Color(0xFF3ACCE1),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getPlatformSize(14.0),
                ),
                for (var drawerItem in _drawerItemList)
                  DrawerItemView(
                    drawerItemModel: drawerItem,
                    isFirstItem: false,
                    isLastItem: false,
                    paddingLeft: MARGIN_LEFT,
                  ),
                SizedBox(
                  height: getPlatformSize(14.0),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              //left: getPlatformSize(MARGIN_LEFT),
              top: getPlatformSize(12.0),
              bottom: getPlatformSize(12.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "v${AppBloc.version}",
                  style: getTextStyle(
                    LanguageName.thai,
                    sizeTh: Constants.Font.SMALLER_SIZE_TH,
                    sizeEn: Constants.Font.SMALLER_SIZE_EN,
                    color: Colors.white.withOpacity(0.7),
                    isBold: true,
                  ),
                ),
                SizedBox(width: getPlatformSize(16.0)),
                Text(
                  "Expressway Authority of Thailand",
                  style: getTextStyle(
                    LanguageName.english,
                    sizeTh: Constants.Font.SMALLER_SIZE_TH,
                    sizeEn: Constants.Font.SMALLER_SIZE_EN,
                    color: Colors.white.withOpacity(0.7),
                    isBold: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
