import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/help_model.dart';
import 'package:flutter/material.dart';
import '../../services/api.dart';
import 'help_page.dart';


class HelpPresenter extends BasePresenter<HelpPage>{
  var ListModel;
  HelpModel helpModel;

  List<String> imgList = [];

  HelpPresenter(State<HelpPage> state) : super(state);


  getHelp() async {
//    print("getHelp");

    try {
      var res = await ExatApi.fetchHelp(state.context);
      setState((){
        helpModel = res;
        helpModel.data.forEach((v) {
          print("ID:${v.id}");
          imgList.add(v.cover);
        });
      });
    } catch (e) {
      print(e);
    }
  }
}