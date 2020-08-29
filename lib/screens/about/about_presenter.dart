import 'package:flutter/material.dart';

import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/about_model.dart';
import 'about_page.dart';

class AboutPresenter extends BasePresenter<AboutPage> {
  AboutModel aboutModel;

  AboutPresenter(State<AboutPage> state) : super(state);

  getAbout() async {
    clearError();

    try {
      var res = await ExatApi.fetchAbout(state.context);
      setState(() {
        aboutModel = res;
      });
      clearError();
      print(aboutModel.data.length);
    } catch (e) {
      setError(1, e.toString());
      print(e);
    }
  }
}
