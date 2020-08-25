import 'package:exattraffic/storage/cctv_favorite_prefs.dart';
import 'package:flutter/material.dart';

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
    return await CctvFavoritePrefs().existId(this.id.toString());
  }

  Future<void> toggleFavorite() async {
    CctvFavoritePrefs prefs = CctvFavoritePrefs();
    if (await isFavoriteOn()) {
      await prefs.removeId(this.id.toString());
    } else {
      await prefs.addId(this.id.toString());
    }
  }
}