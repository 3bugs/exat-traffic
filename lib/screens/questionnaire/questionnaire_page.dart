import 'package:flutter/material.dart';

import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/screens/questionnaire/questionnaire_presenter.dart';
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/constants.dart' as Constants;

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["แบบสอบถาม", "Questionnaire", "问卷调查"];
  int group = 1;
  int myIndex = 0;
  bool showArrorLeft = false;
  bool showArrorRight = true;

  QuestionnairePresenter _presenter;

  Widget _content() {
    return _presenter.questionnaireModel == null
        ? DataLoading()
        : Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      _question(),
                      _sendbutton(),
                    ],
                  ),
                ),
              ),
              _navigator(),
            ],
          );
  }

  Widget _question() {
    return Container(
      alignment: Alignment.topLeft,
      //margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(
        horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
        vertical: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${_presenter.questionnaireModel.data[myIndex].name}",
            style: getTextStyle(
              0,
              sizeTh: Constants.Font.BIGGER_SIZE_TH,
              sizeEn: Constants.Font.BIGGER_SIZE_EN,
            ),
          ),
          SizedBox(
            height: getPlatformSize(5.0),
          ),
          Padding(
              padding: EdgeInsets.only(left: getPlatformSize(10.0)),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: group,
                        onChanged: (T) {
                          setState(() {
                            group = T;
                            print(T);
                          });
                        },
                      ),
                      Text(
                        "1 (ต่ำสุด)",
                        style: getTextStyle(0),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 2,
                        groupValue: group,
                        onChanged: (T) {
                          setState(() {
                            group = T;
                            print(T);
                          });
                        },
                      ),
                      Text(
                        "2",
                        style: getTextStyle(0),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 3,
                        groupValue: group,
                        onChanged: (T) {
                          setState(() {
                            group = T;
                            print(T);
                          });
                        },
                      ),
                      Text(
                        "3",
                        style: getTextStyle(0),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 4,
                        groupValue: group,
                        onChanged: (T) {
                          setState(() {
                            group = T;
                            print(T);
                          });
                        },
                      ),
                      Text(
                        "4",
                        style: getTextStyle(0),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 5,
                        groupValue: group,
                        onChanged: (T) {
                          setState(() {
                            group = T;
                            print(T);
                          });
                        },
                      ),
                      Text(
                        "5 (สูงสุด)",
                        style: getTextStyle(0),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _sendbutton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
        vertical: getPlatformSize(0.0),
      ),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(
          horizontal: getPlatformSize(0.0),
          vertical: getPlatformSize(6.0),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getPlatformSize(30.0)),
//          side: BorderSide(color: Colors.red),
        ),
        onPressed: () {
          print("send");
          _presenter.addAnswers(_presenter.questionnaireModel.data[0].id, group);
        },
        color: Constants.App.PRIMARY_COLOR,
        child: Text(
          "ส่งคำตอบ",
          style: getTextStyle(
            0,
            color: Colors.white,
            sizeTh: Constants.Font.BIGGER_SIZE_TH,
            sizeEn: Constants.Font.BIGGER_SIZE_EN,
          ),
        ),
      ),
    );
  }

  Widget _navigator() {
    return _presenter.questionnaireModel.data.length == 1
        ? Container()
        : Container(
//      color: Colors.red,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      myIndex--;
                      if (myIndex == 0) {
                        showArrorLeft = false;
                      } else if (myIndex < 0) {
                        myIndex = 0;
                      } else {
                        showArrorLeft = true;
                        showArrorRight = true;
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: 60,
                    width: 50,
                    child: Visibility(
                      visible: showArrorLeft,
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: 100,
                  child: Text("${myIndex + 1} / ${_presenter.questionnaireModel.data.length}"),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      myIndex++;
                      if (myIndex == _presenter.questionnaireModel.data.length - 1) {
                        showArrorRight = false;
                      } else if (myIndex > _presenter.questionnaireModel.data.length - 1) {
                        myIndex = _presenter.questionnaireModel.data.length - 1;
                      } else {
                        showArrorLeft = true;
                        showArrorRight = true;
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 60,
                    width: 50,
                    child: Visibility(
                      visible: showArrorRight,
                      child: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  @override
  void initState() {
    _presenter = QuestionnairePresenter(this);
    _presenter.getQuestionnair();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      titleList: _titleList,
      child: _content(),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return YourScaffold(
//      titleList: _titleList,
//
//      // แก้ไขตรง child นี้ได้เลย เพื่อแสดง content ตามที่ต้องการ
//      child: Container(
//        child: ListView.builder(
//          padding: EdgeInsets.symmetric(
//            horizontal: getPlatformSize(16),
//            vertical: getPlatformSize(10),
//          ),
//          itemCount: 3 + 1,
//          itemBuilder: (context, index) {
//            return index == 3
//                ? Container(
//                    padding: EdgeInsets.all(10),
//                    child: RaisedButton(
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(30),
////                    side: BorderSide(color: Colors.red)
//                      ),
//                      onPressed: () {
//                        print("send");
//                      },
//                      color: Colors.blue,
//                      child: Text(
//                        "ส่งแบบสอบถาม",
//                        style: TextStyle(color: Colors.white),
//                      ),
//                    ),
//                  )
//                : Container(
//                    alignment: Alignment.topLeft,
//                    margin: EdgeInsets.only(top: 20),
//                    padding: EdgeInsets.all(10),
////              color: Colors.red,
////              height: 300,
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Text(
//                          "คำถาม",
//                          style: TextStyle(fontSize: 20),
//                        ),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          children: <Widget>[
//                            Radio(
//                              value: 1,
//                              groupValue: group,
//                              onChanged: (T) {
//                                setState(() {
//                                  group = T;
//                                  print(T);
//                                });
//                              },
//                            ),
//                            Text("คำตอบ 1"),
//                          ],
//                        ),
//                        Row(
//                          children: <Widget>[
//                            Radio(
//                              value: 2,
//                              groupValue: group,
//                              onChanged: (T) {
//                                setState(() {
//                                  group = T;
//                                  print(T);
//                                });
//                              },
//                            ),
//                            Text("คำตอบ 2"),
//                          ],
//                        ),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          children: <Widget>[
//                            Radio(
//                              value: 3,
//                              groupValue: group,
//                              onChanged: (T) {
//                                setState(() {
//                                  group = T;
//                                  print(T);
//                                });
//                              },
//                            ),
//                            Text("คำตอบ 3"),
//                          ],
//                        ),
//                        Row(
//                          children: <Widget>[
//                            Radio(
//                              value: 4,
//                              groupValue: group,
//                              onChanged: (T) {
//                                setState(() {
//                                  group = T;
//                                  print(T);
//                                });
//                              },
//                            ),
//                            Text("คำตอบ 4"),
//                          ],
//                        ),
//                      ],
//                    ),
//                  );
//          },
//        ),
//      ),
//    );
//  }
}
