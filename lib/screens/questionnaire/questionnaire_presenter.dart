import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/questionnair_model.dart';
import 'package:exattraffic/screens/questionnaire/questionnaire_page.dart';
import 'package:flutter/material.dart';

import '../../services/api.dart';

class QuestionnairePresenter extends BasePresenter<QuestionnairePage>{
  var ListModel;
  QuestionnaireModel questionnaireModel;

  QuestionnairePresenter(State<QuestionnairePage> state) : super(state);


  getQuestionnair() async {
//    print("getQuestionnair");

    try {
      var res = await ExatApi.fetchQuestions(state.context);

      setState((){
        questionnaireModel = res;
      });

      print(questionnaireModel.data.length);

    } catch (e) {
      print(e);
    }
  }



  }