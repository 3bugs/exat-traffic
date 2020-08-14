import 'dart:async';

import 'package:flutter/material.dart';

import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/components/data_loading.dart';

import 'search_place_presenter.dart';

class SearchPlace extends StatefulWidget {
  const SearchPlace();

  @override
  _SearchPlaceState createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  List<String> _titleList = ["ค้นหาเส้นทาง", "Search", "搜索"];

  final GlobalKey<YourScaffoldState> _keyScaffold = GlobalKey();
  SearchPlacePresenter _presenter;

  void _handleSearchTextChange(String text) {
    _presenter.search(text);
  }

  void _hideKeyboard() {
    _keyScaffold.currentState.hideKeyboard();
  }

  Widget _buildRootContent(double containerHeight) {
    return _presenter.predictionList == null
        ? DataLoading()
        : Stack(
            children: <Widget>[
              _presenter.predictionList.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        top: getPlatformSize(Constants.HomeScreen.SPACE_BEFORE_LIST),
                        bottom: getPlatformSize(8.0 + Constants.BottomSheet.HEIGHT_LAYER),
                      ),
                      child: Text(
                        "ไม่มีข้อมูล",
                        style: getTextStyle(0),
                      ),
                    )
                  : Container(
                      color: Colors.blue.withOpacity(0.5), //Constants.App.BACKGROUND_COLOR,
                      child: ListView.builder(
                        //controller: _scrollController,
                        padding: EdgeInsets.only(
                          top: getPlatformSize(16.0),
                          bottom: getPlatformSize(8.0 + Constants.BottomSheet.HEIGHT_LAYER),
                        ),
                        itemCount: _presenter.predictionList.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            child: Text(_presenter.predictionList[index].description),
                          );
                        },
                      ),
                    ),
            ],
          );
  }

  @override
  void initState() {
    _presenter = SearchPlacePresenter(this);
    //WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      key: _keyScaffold,
      titleList: _titleList,
      showSearch: true,
      onSearchTextChanged: _handleSearchTextChange,
      builder: (BuildContext context, double containerHeight) {
        return _buildRootContent(containerHeight);
      },
    );
  }
}
