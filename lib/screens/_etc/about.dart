import 'package:flutter/material.dart';

import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["เกี่ยวกับเรา", "About Us", "关于我们"];

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      titleList: _titleList,

      // แก้ไขตรง child นี้ได้เลย เพื่อแสดง content ตามที่ต้องการ
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.pink.withOpacity(0.5),
            width: getPlatformSize(10.0),
          ),
        ),
        child: Center(
          child: Text("ABOUT US", style: getTextStyle(LanguageName.thai)),
        ),
      ),
    );
  }
}
