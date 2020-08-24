import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/favorite/components/favorite_view.dart';
import 'package:exattraffic/screens/favorite/favorite_presenter.dart';
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/components/no_data.dart';
import 'package:exattraffic/models/favorite_model.dart';

class Favorite extends StatefulWidget {
  const Favorite(Key key) : super(key: key);

  @override
  FavoriteState createState() => FavoriteState();
}

class FavoriteState extends State<Favorite> {
  FavoritePresenter _presenter;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void onRefresh() {
    _presenter.clearFavoriteList();
    _presenter.getFavoriteList();

    // if failed, use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _handleClickFavoriteItem(FavoriteModel favorite) {
    favorite.marker.showDetailsScreen(context, callback: onRefresh);
  }

  @override
  void initState() {
    _presenter = FavoritePresenter(this);
    _presenter.getFavoriteList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: getPlatformSize(Constants.HomeScreen.SPACE_BEFORE_LIST),
      ),
      decoration: BoxDecoration(
        color: Constants.App.BACKGROUND_COLOR,
      ),
      child: _presenter.favoriteList == null
          ? DataLoading()
          : SmartRefresher(
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: onRefresh,
              child: _presenter.favoriteList.isNotEmpty
                  ? ListView.separated(
                      itemCount: _presenter.favoriteList.length,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            setState(() {
                              _presenter.favoriteList.removeAt(index);
                            });

                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("dismissed")));
                          },
                          child: FavoriteView(
                            onClick: () => _handleClickFavoriteItem(_presenter.favoriteList[index]),
                            favorite: _presenter.favoriteList[index],
                            isFirstItem: index == 0,
                            isLastItem: index == _presenter.favoriteList.length - 1,
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox.shrink();
                      },
                    )
                  : NoData(),
            ),
    );
  }
}
