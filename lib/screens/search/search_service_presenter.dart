import 'package:flutter/material.dart';

import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/environment/base_presenter.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'search_service.dart';

class SearchServicePresenter extends BasePresenter<SearchService> {
  final List<MarkerModel> _markerList;

  List<MarkerModel> get markerList => _markerList;

  SearchServicePresenter(
    State<SearchService> state,
    this._markerList,
  ) : super(state);
}
