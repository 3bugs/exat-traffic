import 'package:flutter/material.dart';

import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/screens/questionnaire/questionnaire_presenter.dart';
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/components/error_view.dart';
import 'package:exattraffic/components/my_button.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/locale_text.dart';

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  LocaleText _title = LocaleText(thai: "แบบสอบถาม", english: "Questionnaire", chinese: "问卷调查");
  int group = 1;
  int myIndex = 0;
  bool showArrowLeft = false;
  bool showArrowRight = true;

  QuestionnairePresenter _presenter;

  Widget _content() {
    return _presenter.error != null
        ? Center(
            child: ErrorView(
              title: "ขออภัย",
              text: _presenter.error.message,
              buttonText: "ลองใหม่",
              withBackground: true,
              onClick: _presenter.getQuestionnaire,
            ),
          )
        : _presenter.questionnaireModel == null
            ? DataLoading()
            : Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          _question(),
                          _sendButton(),
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
              LanguageName.thai,
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
                        style: getTextStyle(LanguageName.thai),
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
                        style: getTextStyle(LanguageName.thai),
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
                        style: getTextStyle(LanguageName.thai),
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
                        style: getTextStyle(LanguageName.thai),
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
                        style: getTextStyle(LanguageName.thai),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _sendButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
        vertical: getPlatformSize(0.0),
      ),
      child: MyButton(
        text: "ส่งคำตอบ",
        onClick: () {
          print("send");
          _presenter.addAnswers(_presenter.questionnaireModel.data[0].id, group);
        },
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
                        showArrowLeft = false;
                      } else if (myIndex < 0) {
                        myIndex = 0;
                      } else {
                        showArrowLeft = true;
                        showArrowRight = true;
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: 60,
                    width: 50,
                    child: Visibility(
                      visible: showArrowLeft,
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
                        showArrowRight = false;
                      } else if (myIndex > _presenter.questionnaireModel.data.length - 1) {
                        myIndex = _presenter.questionnaireModel.data.length - 1;
                      } else {
                        showArrowLeft = true;
                        showArrowRight = true;
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 60,
                    width: 50,
                    child: Visibility(
                      visible: showArrowRight,
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
    _presenter.getQuestionnaire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      title: _title,
      child: _content(),
    );
  }
}
