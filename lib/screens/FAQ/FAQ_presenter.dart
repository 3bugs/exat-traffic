import 'package:flutter/material.dart';

import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/FAQ_model.dart';
import 'FAQ_page.dart';

class FAQPresenter extends BasePresenter<FAQPage> {
  FAQModel faqModel;

  FAQPresenter(State<FAQPage> state) : super(state);

  getFAQ() async {
    clearError();

    try {
      var res = await ExatApi.fetchFAQ(state.context);
      setState(() {
        faqModel = res;
      });
      clearError();
    } catch (e) {
      setError(1, e.toString());
      print(e);
    }
  }

  clearFAQ() {
    setState(() {
      faqModel = null;
    });
  }
}
