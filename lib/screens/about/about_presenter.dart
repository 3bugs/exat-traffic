import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/FAQ_model.dart';
import 'package:exattraffic/models/about_model.dart';
import 'package:flutter/material.dart';

import '../../services/api.dart';
import 'about_page.dart';

class AboutPresenter extends BasePresenter<AboutPage>{
  var ListModel;
  AboutModel aboutModel;

  AboutPresenter(State<AboutPage> state) : super(state);


  getAbout() async {
//    print("getAbout");

    try {
      var res = await ExatApi.fetchAbout(state.context);
      setState((){
        aboutModel = res;
      });
      print(aboutModel.data.length);

    } catch (e) {
      print(e);
    }
  }
}