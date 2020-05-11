import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          0,
          Constants.HomeScreen.MAPS_VERTICAL_POSITION +
              _googleMapsHeight -
              Constants.BottomSheet.HEIGHT_INITIAL,
          0,
          0,
        ),
        end: RelativeRect.fromLTRB(
          0,
          Constants.HomeScreen.SEARCH_BOX_VERTICAL_POSITION - 1,
          0,
          0,
        ),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutExpo,
        ),
      ),
      child: ClipRRect(
        //padding: EdgeInsets.all(getPlatformSize(20.0)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(getPlatformSize(13.0)),
          topRight: Radius.circular(getPlatformSize(13.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: getPlatformSize(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Color(0xFF665EFF),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Color(0xFF5773FF),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Color(0xFF3497FD),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Color(0xFF3ACCE1),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: getPlatformSize(0.0),
                  right: getPlatformSize(0.0),
                  top: getPlatformSize(6.0),
                  bottom: getPlatformSize(0.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: getPlatformSize(56.0), // 42 + 14
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'ทางพิเศษ',
                              style: TextStyle(
                                fontSize: getPlatformSize(16.0),
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF585858),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _handleClickUpDownSheet(context);
                            },
                            borderRadius: BorderRadius.all(
                              Radius.circular(getPlatformSize(21.0)),
                            ),
                            child: Container(
                              width: getPlatformSize(42.0),
                              height: getPlatformSize(42.0),
                              //padding: EdgeInsets.all(getPlatformSize(15.0)),
                              child: Center(
                                child: Image(
                                  image: _bottomSheetExpanded
                                      ? AssetImage(
                                      'assets/images/home/ic_sheet_down.png')
                                      : AssetImage(
                                      'assets/images/home/ic_sheet_up.png'),
                                  width: getPlatformSize(12.0),
                                  height: getPlatformSize(6.7),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getPlatformSize(14.0),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          // list ทางพิเศษ (text)
                          Container(
                            height: getPlatformSize(44.0),
                            child: ListView.separated(
                              itemCount: _expressWayList.length,
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return ExpressWayTextView(
                                  expressWay: _expressWayList[index],
                                  isFirstItem: index == 0,
                                  isLastItem: index == _expressWayList.length - 1,
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  width: getPlatformSize(0.0),
                                );
                              },
                            ),
                          ),
                          // list ด่านทางขึ้น-ลง
                          Expanded(
                            child: Container(
                              child: ListView.separated(
                                itemCount: _tollPlazaList.length,
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return TollPlazaView(
                                    tollPlaza: _tollPlazaList[index],
                                    isFirstItem: index == 0,
                                    isLastItem: index == _tollPlazaList.length - 1,
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    width: getPlatformSize(0.0),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}