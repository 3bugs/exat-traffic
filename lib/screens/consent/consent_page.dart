import 'dart:math';

import 'package:flutter/material.dart';

import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';

class ConsentPage extends StatefulWidget {
  @override
  _ConsentPageState createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = [
    "ข้อกำหนดและเงื่อนไข",
    "Terms And Condition",
    "附带条约"
  ];

  bool checkValue = false;

  String _getDummyText() {
    return new List(1000).fold("", (previousValue, element) => previousValue + "TEST-${Random().nextInt(100).toString()} ");
  }

  Widget _content(){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
//          border: Border.all(
//            color: Colors.black12,
//            width: getPlatformSize(10.0),
//          ),
          color: Colors.white
      ),
      child: Column(
        children: <Widget>[

          _title(),
          _body(),
          _submit(),

        ],
      ),
    );
  }

  Widget _title(){
    return Container(
      child: Center(
        child: Text("ข้อกำหนดและเงื่อนไข", style: getTextStyle(0)),
      ),
    );
  }

  Widget _body(){
    return  Expanded(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Color(0x11000000),
              width: getPlatformSize(10.0),
            ),
            color: Colors.white
        ),
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Text(_getDummyText()),
        ),
      ),
    );
  }

  Widget _submit(){
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (value){
                  setState(() {
                    checkValue = value;
                  });
                },
                value: checkValue,
              ),
              Text("ยอมรับเงื่อนไข"),
            ],
          ),
          Container(
            width: double.maxFinite,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
//                    side: BorderSide(color: Colors.red)
              ),
              onPressed: () {
                print("send");
              },
              color: Colors.blue,
              child: Text(
                "ยืนยัน",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      titleList: _titleList,

      // แก้ไขตรง child นี้ได้เลย เพื่อแสดง content ตามที่ต้องการ
      child: _content(),
    );
  }
}
