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
import 'package:exattraffic/screens/search/search_place_presenter.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/services/google_maps_services.dart';

class Favorite extends StatefulWidget {
  final Function showBestRouteAfterSearch;

  const Favorite(Key key, this.showBestRouteAfterSearch) : super(key: key);

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

  Future<void> _handleClickFavoriteItem(FavoriteModel favorite) async {
    switch (favorite.type) {
      case FavoriteType.cctv:
        favorite.marker.showDetailsScreen(context, callback: onRefresh);
        break;
      case FavoriteType.place:
        final GoogleMapsServices googleMapsServices = GoogleMapsServices();
        _presenter.setLoadingMessage("ดึงข้อมูลสถานที่");
        _presenter.loading();
        try {
          PlaceDetailsModel placeDetails =
              await googleMapsServices.getPlaceDetails(favorite.placeId);
          /*Position destination =
            Position(latitude: placeDetails.latitude, longitude: placeDetails.longitude);*/
          _presenter.setLoadingMessage("หาเส้นทางที่ใช้เวลาน้อยที่สุด");
          RouteModel bestRoute = await SearchPlacePresenter.findBestRoute(context, placeDetails);

          if (bestRoute != null) {
            //assert(bestRoute.gateInCostTollList.isNotEmpty);
            // กลับไป _handleClickSearchOption ใน MyScaffold
            widget.showBestRouteAfterSearch(bestRoute);
          }
        } catch (error) {}
        _presenter.loaded();
        break;
    }
  }

  @override
  void initState() {
    _presenter = FavoritePresenter(this);
    _presenter.getFavoriteList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
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
                            return FavoriteView(
                              onClick: () =>
                                  _handleClickFavoriteItem(_presenter.favoriteList[index]),
                              favorite: _presenter.favoriteList[index],
                              isFirstItem: index == 0,
                              isLastItem: index == _presenter.favoriteList.length - 1,
                            );

                            /*return Dismissible(
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
                          );*/
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox.shrink();
                          },
                        )
                      : NoData(),
                ),
        ),
        _presenter.isLoading ? DataLoading(/*text: _presenter.loadingMessage*/) : SizedBox.shrink(),
      ],
    );
  }
}
