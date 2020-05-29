import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/home/components/express_way.dart';
import 'package:exattraffic/screens/home/components/cctv_item.dart';
import 'package:exattraffic/models/toll_plaza_model.dart';
import 'package:exattraffic/models/express_way_model.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/cctv_model.dart';
import 'package:exattraffic/screens/cctv_details/cctv_details.dart';
import 'package:exattraffic/screens/rest_area_details/rest_area_details.dart';

List<String> expressWayHeaderList = [
  'ทางพิเศษ',
  'Expressway',
  '高速公路',
];

class MyBottomSheet extends StatefulWidget {
  MyBottomSheet({
    @required this.expandPosition,
    @required this.collapsePosition,
  });

  final double expandPosition;
  final double collapsePosition;

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> with TickerProviderStateMixin {
  AnimationController _controller;
  bool _bottomSheetExpanded = false;
  ExpressWayModel _selectedExpressWay;

  initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _bottomSheetExpanded = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _bottomSheetExpanded = false;
        });
      }
    });
    super.initState();
  }

  void _handleClickUpDownSheet(BuildContext context) {
    if (_bottomSheetExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    // toggle _bottomSheetExpanded ใน AnimationController's AnimationStatusListener
  }

  void _handleClickBack(BuildContext context) {
    setState(() {
      _selectedExpressWay = null;
    });
  }

  void _handleClickExpressWay(BuildContext context, ExpressWayModel expressWayModel) {
    setState(() {
      _selectedExpressWay = expressWayModel;
    });
  }

  void _handleClickCctv(BuildContext context, CctvModel cctvModel) {
    //alert(context, 'TEST', chunkModel.name);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CctvDetails(cctvModel)),
      //MaterialPageRoute(builder: (context) => RestAreaDetails(cctvModel)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          0,
          widget.collapsePosition,
          0,
          0,
        ),
        end: RelativeRect.fromLTRB(
          0,
          widget.expandPosition,
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
                          width: getPlatformSize(8.0),
                        ),
                        _selectedExpressWay == null
                            ? SizedBox(
                          width: getPlatformSize(42.0),
                        )
                            : Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _handleClickBack(context);
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
                                  image: AssetImage('assets/images/home/ic_back.png'),
                                  width: getPlatformSize(12.0),
                                  height: getPlatformSize(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Consumer<LanguageModel>(
                              builder: (context, language, child) {
                                String name;
                                if (_selectedExpressWay != null) {
                                  switch (language.lang) {
                                    case 0:
                                      name = _selectedExpressWay.name;
                                      break;
                                    case 1:
                                      name = 'Expressway';
                                      break;
                                    case 2:
                                      name = '高速公路';
                                      break;
                                  }
                                }
                                return Text(
                                  _selectedExpressWay == null
                                      ? expressWayHeaderList[language.lang]
                                      : name,
                                  style: getTextStyle(language.lang, isBold: true),
                                );
                              },
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
                                      ? AssetImage('assets/images/home/ic_sheet_down.png')
                                      : AssetImage('assets/images/home/ic_sheet_up.png'),
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
                      child: IndexedStack(
                        children: <Widget>[
                          ExpressWayList(_handleClickExpressWay),
                          CctvList(_handleClickCctv)
                        ],
                        index: _selectedExpressWay == null ? 0 : 1,
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

class ExpressWayList extends StatelessWidget {
  ExpressWayList(this._onSelectExpressWay);

  final List<ExpressWayModel> _expressWayList = <ExpressWayModel>[
    ExpressWayModel(
      name: 'ทางพิเศษศรีรัช',
      image: AssetImage('assets/images/home/express_way_srirach.jpg'),
    ),
    ExpressWayModel(
      name: 'ทางพิเศษฉลองรัช',
      image: AssetImage('assets/images/home/express_way_chalong.jpg'),
    ),
    ExpressWayModel(
      name: 'ทางพิเศษบูรพาวิถี',
      image: AssetImage('assets/images/home/express_way_burapa.jpg'),
    ),
    ExpressWayModel(
      name: 'ทางพิเศษเฉลิมมหานคร',
      image: AssetImage('assets/images/home/express_way_chalerm.jpg'),
    ),
    ExpressWayModel(
      name: 'ทางพิเศษอุดรรัถยา',
      image: AssetImage('assets/images/home/express_way_udorn.jpg'),
    ),
    ExpressWayModel(
      name: 'ทางพิเศษสายบางนา',
      image: AssetImage('assets/images/home/express_way_bangna.jpg'),
    ),
    ExpressWayModel(
      name: 'ทางพิเศษกาญจนาภิเษก',
      image: AssetImage('assets/images/home/express_way_kanchana.jpg'),
    ),
  ];

  final Function _onSelectExpressWay;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getPlatformSize(110.0),
      child: ListView.separated(
        itemCount: _expressWayList.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          ExpressWayModel selectedExpressWay = _expressWayList[index];

          return ExpressWayImageView(
            expressWay: selectedExpressWay,
            isFirstItem: index == 0,
            isLastItem: index == _expressWayList.length - 1,
            onClick: () {
              _onSelectExpressWay(context, selectedExpressWay);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: getPlatformSize(0.0),
          );
        },
      ),
    );
  }
}

class CctvList extends StatefulWidget {
  CctvList(this._onSelectCctv);

  final List<CctvModel> _cctvList = <CctvModel>[
    CctvModel(
      name: 'ทางลงลาดพร้าว',
      image: AssetImage('assets/images/home/toll_plaza_dummy_1.jpg'),
    ),
    CctvModel(
      name: 'รามอินทรา',
      image: AssetImage('assets/images/home/toll_plaza_dummy_2.jpg'),
    ),
    CctvModel(
      name: 'สุขาภิบาล 5',
      image: AssetImage('assets/images/home/toll_plaza_dummy_1.jpg'),
    ),
    CctvModel(
      name: 'โยธิน',
      image: AssetImage('assets/images/home/toll_plaza_dummy_2.jpg'),
    ),
  ];

  final Function _onSelectCctv;

  @override
  _CctvListState createState() => _CctvListState();
}

class _CctvListState extends State<CctvList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // list ทางพิเศษ (text), todo: เปลี่ยนเป็น route
        Container(
          height: getPlatformSize(44.0),
          child: ListView.separated(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return ExpressWayTextView(
                expressWay: ExpressWayModel(
                  name: 'ทางพิเศษศรีรัช',
                  image: AssetImage('assets/images/home/express_way_srirach.jpg'),
                ),
                isFirstItem: index == 0,
                isLastItem: index == 4,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox.shrink();
            },
          ),
        ),
        // list ด่านทางขึ้น-ลง
        Expanded(
          child: Container(
            child: ListView.separated(
              itemCount: widget._cctvList.length,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                CctvModel selectedCctv = widget._cctvList[index];

                return CctvItemView(
                  cctvModel: selectedCctv,
                  isFirstItem: index == 0,
                  isLastItem: index == widget._cctvList.length - 1,
                  onClick: () {
                    widget._onSelectCctv(context, selectedCctv);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }
}