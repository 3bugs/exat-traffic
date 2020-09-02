import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/screens/search/components/search_place_view.dart';
import 'package:exattraffic/services/google_maps_services.dart';
import 'package:exattraffic/components/no_data.dart';
import 'package:exattraffic/models/locale_text.dart';

import 'search_place_presenter.dart';

class SearchPlace extends StatefulWidget {
  static const String DUMMY_PLACE_ID = "place-id";
  const SearchPlace();

  @override
  _SearchPlaceState createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  LocaleText _title = LocaleText(thai: "ค้นหาเส้นทาง", english: "Search", chinese: "搜索");

  final GlobalKey<YourScaffoldState> _keyScaffold = GlobalKey();
  SearchPlacePresenter _presenter;

  void _handleSearchTextChange(String text) {
    _presenter.search(text);
  }

  void _hideKeyboard() {
    _keyScaffold.currentState.hideKeyboard();
  }

  Widget _buildRootContent(double containerHeight) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          color: Constants.App.BACKGROUND_COLOR,
          child: _presenter.searchResultList != null ? _buildSearchResult() : SizedBox.shrink(),
        ),
        //_presenter.searchResultList != null ? _buildSearchResult() : SizedBox.shrink(),
        _presenter.showPredictionList ? _buildAutoSuggest() : SizedBox.shrink(),
        _presenter.isLoading ? DataLoading() : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildSearchResult() {
    if (_presenter.searchResultList.isEmpty) {
      return NoData();
    } else {
      return ListView.builder(
        //controller: _scrollController,
        padding: EdgeInsets.only(
          top: getPlatformSize(Constants.HomeScreen.SPACE_BEFORE_LIST),
          bottom: getPlatformSize(8.0),
        ),
        itemCount: _presenter.searchResultList.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          List<SearchResultModel> searchResultList = _presenter.searchResultList;
          return SearchPlaceView(
            searchResult: searchResultList[index],
            isFirstItem: index == 0,
            isLastItem: index == searchResultList.length - 1,
            onClick: () => _presenter.handleClickSearchResultItem(context, searchResultList[index]),
          );
        },
      );
    }
  }

  Widget _buildAutoSuggest() {
    if (_presenter.searchTerm != null && _presenter.searchTerm.trim().isNotEmpty) {
      List<PredictionModel> predictionListFromApi =
          _presenter.predictionList ?? List<PredictionModel>();

      List<PredictionModel> predictionList = [
        PredictionModel(
          description: "ค้นหา '${_presenter.searchTerm}'",
          distanceMeters: 0,
          placeId: SearchPlace.DUMMY_PLACE_ID,
        ),
        ...predictionListFromApi
      ];

      return Positioned(
        width: MediaQuery.of(context).size.width,
        top: getPlatformSize(28.0),
        left: 0.0,
        child: Padding(
          padding: EdgeInsets.only(
            left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
            right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x22777777),
                  blurRadius: getPlatformSize(6.0),
                  spreadRadius: getPlatformSize(3.0),
                  offset: Offset(
                    getPlatformSize(1.0), // move right
                    getPlatformSize(1.0), // move down
                  ),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
              ),
            ),
            child: Column(
              children: predictionList
                  .asMap()
                  .entries
                  .map<PredictionItemView>(
                    (entry) => PredictionItemView(
                      text: entry.value.description,
                      isFirstItem: entry.key == 0,
                      isLastItem: entry.key == _presenter.predictionList.length,
                      onClick: () {
                        _hideKeyboard();
                        _presenter.handleClickPredictionItem(context, entry.value);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
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
      title: _title,
      showSearch: true,
      searchBoxAutoFocus: true,
      searchBoxHint: "พิมพ์ชื่อสถานที่",
      onSearchTextChanged: _handleSearchTextChange,
      builder: (BuildContext context, double containerHeight) {
        return _buildRootContent(containerHeight);
      },
    );
  }
}

class PredictionItemView extends StatelessWidget {
  final String text;
  final bool isFirstItem;
  final bool isLastItem;
  final Function onClick;

  PredictionItemView({
    @required this.text,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.only(
          topLeft: this.isFirstItem
              ? Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS))
              : Radius.zero,
          topRight: this.isFirstItem
              ? Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS))
              : Radius.zero,
          bottomLeft: this.isLastItem
              ? Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS))
              : Radius.zero,
          bottomRight: this.isLastItem
              ? Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS))
              : Radius.zero,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: getPlatformSize(isFirstItem ? 10.0 : 5.0),
            bottom: getPlatformSize(isFirstItem || isLastItem ? 10.0 : 5.0),
            left: getPlatformSize(20.0),
            right: getPlatformSize(20.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: getPlatformSize(10.0),
                height: getPlatformSize(10.0),
                margin: EdgeInsets.only(
                  top: getPlatformSize(10.0),
                  right: getPlatformSize(16.0),
                ),
                decoration: BoxDecoration(
                  color: Color(isFirstItem ? 0xFF3497FD : 0xFF3ACCE1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(getPlatformSize(3.0)),
                  ),
                ),
              ),
              Expanded(
                child: Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    return Text(
                      this.text,
                      style: getTextStyle(
                        language.lang,
                        color: Color(0xFF454F63),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    /*Container(
      margin: EdgeInsets.only(
        left: getPlatformSize(20.0),
        right: getPlatformSize(20.0),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF4F4F4),
            width: getPlatformSize(1.0),
          ),
        ),
      ),
    ),*/
  }
}
