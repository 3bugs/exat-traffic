import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/express_way_model.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/cctv_model.dart';
import 'package:exattraffic/screens/cctv_details/cctv_details.dart';

import 'components/bottom_sheet_scaffold.dart';
import 'components/express_way.dart';
import 'components/cctv_item.dart';

List<String> expressWayHeaderList = [
  'ทางพิเศษ',
  'Expressway',
  '高速公路',
];

class HomeBottomSheet extends StatefulWidget {
  HomeBottomSheet({
    @required this.expandPosition,
    @required this.collapsePosition,
  });

  final double expandPosition;
  final double collapsePosition;

  @override
  _HomeBottomSheetState createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet>  {
  final GlobalKey<BottomSheetScaffoldState> _keyBottomSheetScaffold = GlobalKey();

  LayerItemModel _selectedExpressWay;
  bool _bottomSheetExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleClickUpDownSheet() {
    _keyBottomSheetScaffold.currentState.toggleSheet();
  }

  void _handleChangeSize(bool sheetExpanded) {
    setState(() {
      _bottomSheetExpanded = sheetExpanded;
    });
  }

  void _handleClickBack(BuildContext context) {
    setState(() {
      _selectedExpressWay = null;
    });
  }

  void _handleClickExpressWay(BuildContext context, LayerItemModel expressWayModel) {
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
    return BottomSheetScaffold(
      key: _keyBottomSheetScaffold,
      expandPosition: widget.expandPosition,
      collapsePosition: widget.collapsePosition,
      onChangeSize: _handleChangeSize,
      child: Expanded(
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
                        _handleClickUpDownSheet();
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
                            //image: AssetImage('assets/images/home/ic_sheet_down.png'),
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
    );
  }
}

class ExpressWayList extends StatelessWidget {
  ExpressWayList(this._onSelectExpressWay);

  final List<LayerItemModel> _expressWayList = <LayerItemModel>[
    LayerItemModel(
      name: 'ทางพิเศษศรีรัช',
      image: AssetImage('assets/images/home/express_way_srirach.jpg'),
    ),
    LayerItemModel(
      name: 'ทางพิเศษฉลองรัช',
      image: AssetImage('assets/images/home/express_way_chalong.jpg'),
    ),
    LayerItemModel(
      name: 'ทางพิเศษบูรพาวิถี',
      image: AssetImage('assets/images/home/express_way_burapa.jpg'),
    ),
    LayerItemModel(
      name: 'ทางพิเศษเฉลิมมหานคร',
      image: AssetImage('assets/images/home/express_way_chalerm.jpg'),
    ),
    LayerItemModel(
      name: 'ทางพิเศษอุดรรัถยา',
      image: AssetImage('assets/images/home/express_way_udorn.jpg'),
    ),
    LayerItemModel(
      name: 'ทางพิเศษสายบางนา',
      image: AssetImage('assets/images/home/express_way_bangna.jpg'),
    ),
    LayerItemModel(
      name: 'ทางพิเศษกาญจนาภิเษก',
      image: AssetImage('assets/images/home/express_way_kanchana.jpg'),
    ),
  ];

  final Function _onSelectExpressWay;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getPlatformSize(120.0),
      child: ListView.separated(
        itemCount: _expressWayList.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          LayerItemModel selectedExpressWay = _expressWayList[index];

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
                expressWay: LayerItemModel(
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