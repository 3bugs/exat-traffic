import 'dart:async';

import 'package:flutter/material.dart';

import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/screens/search/components/search_service_view.dart';
import 'search_service_presenter.dart';

class SearchService extends StatefulWidget {
  final List<MarkerModel> markerList;

  SearchService(this.markerList);

  @override
  _SearchServiceState createState() => _SearchServiceState();
}

class _SearchServiceState extends State<SearchService> {
  List<String> _titleList = ["ค้นหาบริการ", "Search", "搜索"];

  SearchServicePresenter _presenter;
  String _searchText = "";
  final _scrollController = ScrollController();

  void _handleClickSearchResultItem(MarkerModel marker) {
    if (marker.category.code == CategoryType.TOLL_PLAZA) {
      // bottom sheet
      underConstruction(this.context);
    } else {
      marker.showDetailsScreen(this.context);
    }
  }

  void _handleSearchTextChange(String text) {
    setState(() {
      _searchText = text;
    });
  }

  Widget _buildRootContent() {
    List<MarkerModel> filteredMarkerList = _presenter.markerList;
    if (filteredMarkerList != null) {
      List<String> searchWordList = _searchText.split(RegExp('\\s+'));
      searchWordList.forEach((word) {
        filteredMarkerList =
            filteredMarkerList.where((marker) => marker.name.contains(word)).toList();
      });
    }

    if (filteredMarkerList != null) {
      Timer(
        Duration(milliseconds: 100),
        () => _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
        ),
      );
    }

    return filteredMarkerList == null
        ? DataLoading()
        : Container(
            color: Color(0x09000000),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: getPlatformSize(0.0),
                vertical: getPlatformSize(16.0),
              ),
              itemCount: filteredMarkerList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return SearchServiceView(
                  onClick: () => _handleClickSearchResultItem(filteredMarkerList[index]),
                  marker: filteredMarkerList[index],
                  isFirstItem: index == 0,
                  isLastItem: index == filteredMarkerList.length - 1,
                );
              },
            ),
          );
  }

  @override
  void initState() {
    widget.markerList.sort((a, b) => a.category.code.compareTo(b.category.code));
    _presenter = SearchServicePresenter(this, widget.markerList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      titleList: _titleList,
      showSearch: true,
      //onClickSearchCloseButton: _handleClickSearchCloseButton,
      onSearchTextChanged: _handleSearchTextChange,
      child: _buildRootContent(),
    );
  }
}
