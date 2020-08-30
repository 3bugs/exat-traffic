import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/add_answers_model.dart';
import 'package:exattraffic/models/questionnair_model.dart';
import 'package:exattraffic/screens/questionnaire/questionnaire_page.dart';

class QuestionnairePresenter extends BasePresenter<QuestionnairePage> {
  QuestionnaireModel questionnaireModel;
  AddAnswersModel addAnswersModel;

  QuestionnairePresenter(State<QuestionnairePage> state) : super(state);

  getQuestionnaire() async {
    clearError();

    try {
      var res = await ExatApi.fetchQuestions(state.context);

      setState(() {
        questionnaireModel = res;
      });
      clearError();
    } catch (e) {
      setError(1, e.toString());
      print(e);
    }
  }

  addAnswers(int id, int score, String detail) async {
//    print("addAnswers");
    setState(() {
      addAnswersModel = null;
    });

    try {
      var res = await ExatApi.addAnswers(state.context, id.toString(), score.toString(),detail);
      Alert(
        context: state.context,
        type: AlertType.success,
        title: "สำเร็จ",
        desc: "ส่งแบบสอบถามสำเร็จ",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(state.context),
            width: 120,
          )
        ],
      ).show();

      setState(() {
        addAnswersModel = res;
      });

      print(addAnswersModel.data);
    } catch (e) {
      print(e);
      Alert(
        context: state.context,
        type: AlertType.error,
        title: "เกิดข้อผิดพลาด",
        desc: "$e",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(state.context),
            width: 120,
          )
        ],
      ).show();
    }
  }
}
