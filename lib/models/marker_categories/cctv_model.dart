import 'package:flutter/material.dart';

import 'package:exattraffic/etc/preferences.dart';

class CctvModel {
  CctvModel(this.id, {
    @required this.name,
    @required this.imageUrl,
    @required this.streamUrl,
  });

  final int id;
  final String name;
  final String imageUrl;
  final String streamUrl;

  Future<bool> isFavoriteOn() async {
    return await MyPrefs().existCctvFavorite(this);
  }

  Future<void> toggleFavorite() async {
    if (await isFavoriteOn()) {
      await MyPrefs().removeCctvFavorite(this);
    } else {
      await MyPrefs().addCctvFavorite(this);
    }
  }
}