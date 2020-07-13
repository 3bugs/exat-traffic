import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/services/api.dart';
import 'package:flutter/cupertino.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final BuildContext context;

  AppBloc({this.context}) : super(MarkerInitial());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    final currentState = state;

    if (event is FetchMarker) {
      try {
        final markerList = await ExatApi.fetchMarkers(context);
        yield MarkerSuccess(markerList: markerList);
      } catch (_) {
        yield MarkerFailure();
      }
    }
  }
}