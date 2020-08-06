import 'package:exattraffic/models/drawer_item_model.dart';
import 'package:exattraffic/screens/FAQ/FAQ_page.dart';
import 'package:exattraffic/screens/about/about_page.dart';
import 'package:exattraffic/screens/consent/consent_page.dart';
import 'package:exattraffic/screens/help/help_page.dart';
import 'package:exattraffic/screens/home/components/drawer_item_view.dart';
import 'package:exattraffic/screens/questionnaire/questionnaire_page.dart';
import 'package:flutter/material.dart';
import 'package:exattraffic/etc/utils.dart';

import '../../_etc/test_overlap.dart';

class MyDrawer extends StatelessWidget {
  static final double MARGIN_LEFT = 34.0;

  MyDrawer();

  final List<DrawerItemModel> _drawerItemList = [
    DrawerItemModel(
      text: 'เกี่ยวกับเรา',
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
      text: 'แบบสอบถาม',
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
      text: 'การตั้งค่า',
      icon: AssetImage('assets/images/drawer/ic_settings.png'),
      onClick: (BuildContext context) {
        Navigator.pop(context);
      },
    ),
    DrawerItemModel(
      text: 'ความช่วยเหลือ',
      icon: AssetImage('assets/images/drawer/ic_help.png'),
      onClick: (BuildContext context) {
        Navigator.pop(context);
      },
    ),
    DrawerItemModel(
      text: 'วิดเจ็ต',
      icon: AssetImage('assets/images/drawer/ic_widget.png'),
      onClick: (BuildContext context) {
        Navigator.pop(context);
      },
    ),

    DrawerItemModel(
      text: 'ข้อกำหนดและเงื่อนไข',
      icon: AssetImage('assets/images/drawer/ic_widget.png'),
      onClick: (BuildContext context) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConsentPage(),
          ),
        );
      },
    ),

    DrawerItemModel(
      text: 'FAQ',
      icon: AssetImage('assets/images/drawer/ic_widget.png'),
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
      text: 'Help',
      icon: AssetImage('assets/images/drawer/ic_widget.png'),
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
      text: 'ออกจากระบบ',
      icon: AssetImage('assets/images/drawer/ic_logout.png'),
      onClick: (BuildContext context) {
        Navigator.pop(context);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2D4F80),
      ),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
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
                          image: AssetImage('assets/images/drawer/promlert.jpg'),
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
                        'พร้อมเลิศ หล่อวิจิตร',
                        //'Promlert Lovichit',
                        style: getTextStyle(
                          1,
                          sizeEn: 22.0,
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
    );
  }
}
