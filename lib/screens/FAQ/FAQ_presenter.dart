import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/FAQ_model.dart';
import 'package:exattraffic/models/questionnair_model.dart';
import 'package:flutter/material.dart';

import '../../services/api.dart';
import 'FAQ_page.dart';

class FAQPresenter extends BasePresenter<FAQPage>{
  var ListModel;
  FAQModel faqModel;

  FAQPresenter(State<FAQPage> state) : super(state);


  getFAQ() async {
//    print("getFAQ");

    try {
      var res = await ExatApi.fetchFAQ(state.context);
      setState((){
        faqModel = res;
      });
      print(faqModel.data.length);

    } catch (e) {
      print(e);
    }
  }
}