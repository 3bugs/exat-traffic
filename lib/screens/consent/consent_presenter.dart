import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/consent_model.dart';
import 'package:flutter/material.dart';

import '../../services/api.dart';
import 'consent_page.dart';

class ConsentPresenter extends BasePresenter<ConsentPage> {
  ConsentModel consentModel;

  ConsentPresenter(State<ConsentPage> state) : super(state);
  
  getConsent() async {
//    print("getConsent");

    try {
      var res = await ExatApi.fetchConsent(state.context);
      setState(() {
        consentModel = res;
      });
      print(consentModel.data.length);
    } catch (e) {
      print(e);
    }
  }
}
