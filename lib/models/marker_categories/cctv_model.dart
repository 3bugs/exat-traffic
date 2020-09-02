import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/storage/cctv_favorite_prefs.dart';

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

  Future<bool> isFavoriteOn(BuildContext context) async {
    CctvFavoritePrefs prefs = Provider.of<CctvFavoritePrefs>(context, listen: false);
    return await prefs.existId(this.id.toString());
    //return await CctvFavoritePrefs().existId(this.id.toString());
  }

  Future<void> toggleFavorite(BuildContext context) async {
    CctvFavoritePrefs prefs = Provider.of<CctvFavoritePrefs>(context, listen: false);
    //CctvFavoritePrefs prefs = CctvFavoritePrefs();
    if (await isFavoriteOn(context)) {
      await prefs.removeId(this.id.toString());
    } else {
      await prefs.addId(this.id.toString());
    }
  }
}