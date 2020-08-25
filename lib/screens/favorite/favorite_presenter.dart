import 'favorite.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/favorite_model.dart';
import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/storage/cctv_favorite_prefs.dart';

class FavoritePresenter extends BasePresenter<Favorite> {
  List<FavoriteModel> favoriteList;
  State<Favorite> state;

  FavoritePresenter(this.state) : super(state);

  getFavoriteList() async {
    List<MarkerModel> markerList = BlocProvider.of<AppBloc>(state.context).markerList;
    List<String> cctvIdList = await CctvFavoritePrefs().getIdList();
    List<MarkerModel> cctvList = markerList
        .where((marker) => (cctvIdList != null && cctvIdList.contains(marker.id.toString())))
        .toList();

    setState(() {
      favoriteList = cctvList
          .map<FavoriteModel>((cctvMarker) => FavoriteModel(
                name: cctvMarker.name,
                description: cctvMarker.routeName ?? "กล้อง CCTV",
                //"${cctvMarker.latitude}, ${cctvMarker.longitude}",
                type: FavoriteType.cctv,
                marker: cctvMarker,
              ))
          .toList();
    });
  }

  clearFavoriteList() {
    setState(() {
      favoriteList = null;
    });
  }
}
