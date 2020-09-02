import 'package:exattraffic/models/language_model.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/components/my_button.dart';

import 'consent_presenter.dart';

class ConsentPage extends StatefulWidget {
  @override
  _ConsentPageState createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["ข้อตกลงและเงื่อนไข", "Terms And Condition", "附带条约"];

  bool checkValue = false;
  ConsentPresenter _presenter;

  Widget _content() {
    return _presenter.consentModel == null
        ? DataLoading()
        : Container(
            color: Constants.App.BACKGROUND_COLOR,
            padding: EdgeInsets.symmetric(
              horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
              vertical: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
            ),
            //padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                _title(),
                _body(),
                _submit(),
              ],
            ),
          );
  }

  Widget _title() {
    return Container(
      padding: EdgeInsets.only(bottom: getPlatformSize(8.0)),
      child: Center(
        child: Text(
          _presenter.consentModel.data[0].title,
          style: getTextStyle(
            LanguageName.thai,
            sizeEn: Constants.Font.BIGGER_SIZE_EN,
            sizeTh: Constants.Font.BIGGER_SIZE_TH,
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            border: Border.all(
              color: Color(0x11000000),
              width: getPlatformSize(10.0),
            ),
            color: Colors.white),
        padding: EdgeInsets.all(getPlatformSize(10.0)),
        child: SingleChildScrollView(
          child: Text(
            _presenter.consentModel.data[0].content,
            style: getTextStyle(LanguageName.thai),
          ),
        ),
      ),
    );
  }

  Widget _submit() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (value) {
                  setState(() {
                    checkValue = value;
                  });
                },
                value: checkValue,
              ),
              Text(
                "ยอมรับเงื่อนไข",
                style: getTextStyle(LanguageName.thai),
              ),
            ],
          ),
          MyButton(
            text: "ยืนยัน",
            onClick: () {
              if (checkValue) {
                print("send");
                Navigator.pop(context);
              } else {
                Alert(
                  context: context,
                  type: AlertType.error,
                  title: "เกิดข้อผิดพลาด",
                  desc: "กรุณากดยอมรับเงื่อนไข",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "OK",
                        style: getTextStyle(
                          LanguageName.thai,
                          color: Colors.white,
                          sizeTh: Constants.Font.BIGGER_SIZE_TH,
                          sizeEn: Constants.Font.BIGGER_SIZE_EN,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      width: 120,
                    )
                  ],
                ).show();
              }
            },
          ),
          /*Container(
            width: double.maxFinite,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
//                    side: BorderSide(color: Colors.red)
              ),
              onPressed: () {
                if (checkValue) {
                  print("send");
                  Navigator.pop(context);
                } else {
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "เกิดข้อผิดพลาด",
                    desc: "กรุณากดยอมรับเงือนไข",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                  ).show();
                }
              },
              color: Colors.blue,
              child: Text(
                "ยืนยัน",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  @override
  void initState() {
    _presenter = ConsentPresenter(this);
    _presenter.getConsent();
    super.initState();
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
