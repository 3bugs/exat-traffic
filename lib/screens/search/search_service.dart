import 'dart:async';

import 'package:flutter/material.dart';

import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/screens/search/components/search_service_view.dart';
import 'package:exattraffic/models/marker_categories/toll_plaza_model.dart';
import 'package:exattraffic/screens/bottom_sheet/components/layer_item.dart';
import 'package:exattraffic/screens/bottom_sheet/layer_bottom_sheet.dart';
import 'package:exattraffic/screens/bottom_sheet/toll_plaza_bottom_sheet.dart';
import 'package:exattraffic/components/no_data.dart';
import 'package:exattraffic/models/locale_text.dart';
import 'package:exattraffic/services/api.dart';

import 'search_service_presenter.dart';

class SearchService extends StatefulWidget {
  final List<CategoryModel> categoryList;
  final List<MarkerModel> markerList;

  SearchService({
    @required this.categoryList,
    @required this.markerList,
  });

  @override
  _SearchServiceState createState() => _SearchServiceState();
}

class _SearchServiceState extends State<SearchService> {
  LocaleText _title = LocaleText.searchService();

  //final GlobalKey _keyMainContainer = GlobalKey();
  //double _mainContainerTop = 0; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  //double _mainContainerHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()

  Map<CategoryModel, bool> _categorySelectedStatusMap = Map();

  SearchServicePresenter _presenter;
  String _searchText = "";
  final _scrollController = ScrollController();
  final GlobalKey<TollPlazaBottomSheetState> _keyTollPlazaBottomSheet = GlobalKey();
  final GlobalKey<YourScaffoldState> _keyScaffold = GlobalKey();
  TollPlazaModel _tollPlaza;

  /*_afterLayout(_) {
    final RenderBox mainContainerRenderBox = _keyMainContainer.currentContext.findRenderObject();
    setState(() {
      _mainContainerTop = mainContainerRenderBox.localToGlobal(Offset.zero).dy;
      _mainContainerHeight = mainContainerRenderBox.size.height;
    });
  }*/

  void _handleClickSearchResultItem(MarkerModel marker) {
    if (marker.category.code == CategoryType.TOLL_PLAZA) {
      // bottom sheet
      setState(() {
        _tollPlaza = TollPlazaModel.fromMarkerModel(marker);
        _keyTollPlazaBottomSheet.currentState.toggleSheet();
      });

      MyApi.usageLog(
        context: context,
        pageName: 'map_marker',
        pageKey: 'toll_plaza',
        pageData: marker.name,
      );
    } else {
      marker.showDetailsScreen(this.context);
    }

    _keyScaffold.currentState.hideKeyboard();
  }

  void _handleSearchTextChange(String text) {
    setState(() {
      _searchText = text;
    });
    _scrollListToTop();
  }

  void _scrollListToTop() {
    Timer(
      Duration(milliseconds: 200),
      () {
        try {
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
          );
        } catch (_) {}
      },
    );
  }

  Widget _buildRootContent(double containerHeight) {
    /*double containerHeight = InheritedDataProvider.of(context) != null
        ? InheritedDataProvider.of(context).containerHeight
        : 123.456;*/

    List<MarkerModel> filteredMarkerList = _presenter.markerList;
    if (filteredMarkerList != null) {
      // filter by category
      filteredMarkerList = filteredMarkerList.where((marker) {
        return widget.categoryList
            .where((category) =>
                _categorySelectedStatusMap[category] && category.code == marker.category.code)
            .toList()
            .isNotEmpty;
      }).toList();

      // filter by search term
      List<String> searchWordList = _searchText.split(RegExp('\\s+'));
      searchWordList.forEach((word) {
        filteredMarkerList = filteredMarkerList
            .where((marker) => marker.name.toLowerCase().contains(word.toLowerCase()))
            .toList();
      });
    }

    if (filteredMarkerList != null && filteredMarkerList.isNotEmpty) {
      /*Timer(
        Duration(milliseconds: 100),
        () {
          try {
            _scrollController.animateTo(
              0.0,
              duration: Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
            );
          } catch (_) {}
        },
      );*/
    }

    return filteredMarkerList == null
        ? DataLoading()
        : Stack(
            children: <Widget>[
              filteredMarkerList.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        top: getPlatformSize(Constants.HomeScreen.SPACE_BEFORE_LIST),
                        bottom: getPlatformSize(8.0 + Constants.BottomSheet.HEIGHT_LAYER),
                      ),
                      child: NoData(),
                    )
                  : Container(
                      //color: Constants.App.BACKGROUND_COLOR,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          top: getPlatformSize(16.0),
                          bottom: getPlatformSize(8.0 + Constants.BottomSheet.HEIGHT_LAYER),
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
                    ),
              LayerBottomSheet(
                collapsePosition:
                    containerHeight - getPlatformSize(Constants.BottomSheet.HEIGHT_LAYER),
                // expandPosition ไม่ได้ใช้ เพราะ layer bottom sheet ยืดไม่ได้
                expandPosition: getPlatformSize(0.0),
                child: ListView.separated(
                  itemCount: widget.categoryList.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    CategoryModel category = widget.categoryList[index];

                    return LayerItemView(
                      layerItem: category,
                      isFirstItem: index == 0,
                      isLastItem: index == widget.categoryList.length - 1,
                      selected: _categorySelectedStatusMap[category],
                      onClick: () {
                        setState(() {
                          _categorySelectedStatusMap[category] =
                              !_categorySelectedStatusMap[category];
                        });
                        _scrollListToTop();
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: getPlatformSize(0.0),
                    );
                  },
                ),
              ),
              TollPlazaBottomSheet(
                key: _keyTollPlazaBottomSheet,
                collapsePosition: containerHeight,
                expandPosition: getPlatformSize(Constants.HomeScreen.MAP_TOOL_TOP_POSITION),
                tollPlazaModel: _tollPlaza,
              )
            ],
          );
  }

  @override
  void initState() {
    //_categoryList = BlocProvider.of<AppBloc>(context).categoryList;
    widget.categoryList.forEach((category) {
      _categorySelectedStatusMap[category] = true;
    });

    widget.markerList.sort((a, b) => a.category.code.compareTo(b.category.code));
    _presenter = SearchServicePresenter(this, widget.markerList);
    //WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      key: _keyScaffold,
      title: _title,
      showSearch: true,
      onSearchTextChanged: _handleSearchTextChange,
      builder: (BuildContext context, double containerHeight) {
        return Container(
          color: Constants.App.BACKGROUND_COLOR,
          child: _buildRootContent(containerHeight),
        );
      },
    );
  }
}
