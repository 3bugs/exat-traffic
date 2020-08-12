import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/favorite_model.dart';
import 'package:exattraffic/screens/favorite/components/favorite_view.dart';

class Favorite extends StatefulWidget {
  const Favorite();

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<FavoriteModel> _favoriteList = <FavoriteModel>[
    FavoriteModel(
      name: 'กระทรวงพาณิชย์',
      description: 'ทางพิเศษศรีรัช 130 กม.',
    ),
    FavoriteModel(
      name: 'ศูนย์ราชการแจ้งวัฒนะ',
      description: 'ทางพิเศษศรีรัช 189 กม.',
    ),
    FavoriteModel(
      name: 'บ้าน',
      description: 'ทางพิเศษศรีรัช 40 กม.',
    ),
    FavoriteModel(
      name: 'พระราม 2',
      description: 'ทางพิเศษศรีรัช 89 กม.',
    ),
    FavoriteModel(
      name: 'อารีย์',
      description: 'ทางพิเศษศรีรัช 45 กม.',
    ),
    FavoriteModel(
      name: 'อารีย์',
      description: 'ทางพิเศษศรีรัช 45 กม.',
    ),
    FavoriteModel(
      name: 'อารีย์',
      description: 'ทางพิเศษศรีรัช 45 กม.',
    ),
    FavoriteModel(
      name: 'อารีย์',
      description: 'ทางพิเศษศรีรัช 45 กม.',
    ),
    FavoriteModel(
      name: 'อารีย์',
      description: 'ทางพิเศษศรีรัช 45 กม.',
    ),
    FavoriteModel(
      name: 'อารีย์',
      description: 'ทางพิเศษศรีรัช 45 กม.',
    ),
  ];

  @override
  void initState() {
    print('FAVORITE SCREEN');
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
      child: ListView.separated(
        itemCount: _favoriteList.length,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          //final favorite = _favoriteList[index];

          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                _favoriteList.removeAt(index);
              });

              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text("dismissed")));
            },
            child: FavoriteView(
              favorite: _favoriteList[index],
              isFirstItem: index == 0,
              isLastItem: index == _favoriteList.length - 1,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox.shrink();
        },
      ),
    );
  }
}
