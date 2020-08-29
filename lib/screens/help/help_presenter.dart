import 'package:flutter/material.dart';

import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/help_model.dart';
import 'help_page.dart';

class HelpPresenter extends BasePresenter<HelpPage>{
  HelpModel helpModel;

  List<String> imgList = [];

  HelpPresenter(State<HelpPage> state) : super(state);

  getHelp() async {
    clearError();

    try {
      var res = await ExatApi.fetchHelp(state.context);
      setState((){
        helpModel = res;
        helpModel.data.forEach((v) {
          print("ID:${v.id}");
          imgList.add(v.cover);
        });
      });
      clearError();
    } catch (e) {
      setError(1, e.toString());
      print(e);
    }
  }
}