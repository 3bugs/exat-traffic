import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/layer_item_model.dart';

import 'components/bottom_sheet_scaffold.dart';
import 'components/layer_item.dart';

class LayerBottomSheet extends StatefulWidget {
  LayerBottomSheet({
    @required this.expandPosition,
    @required this.collapsePosition,
  });

  final double expandPosition;
  final double collapsePosition;

  @override
  _LayerBottomSheetState createState() => _LayerBottomSheetState();
}

class _LayerBottomSheetState extends State<LayerBottomSheet> {
  final GlobalKey<BottomSheetScaffoldState> _keyBottomSheetScaffold = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _handleChangeSize(bool sheetExpanded) {}

  void _handleSelectLayerItem(BuildContext context, LayerItemModel layerItemModel) {
    //alert(context, 'Layer Item isChecked', layerItemModel.isChecked ? 'TRUE' : 'FALSE');
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
            top: getPlatformSize(18.0),
            bottom: getPlatformSize(0.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: LayerItemList(_handleSelectLayerItem),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LayerItemList extends StatefulWidget {
  LayerItemList(this._onSelectLayerItem);

  final List<LayerItemModel> _layerItemModelList = <LayerItemModel>[
    LayerItemModel(
      text: 'ด่านเก็บเงิน',
      textEn: 'Toll Plaza',
      iconOn: AssetImage('assets/images/layers/ic_layer_toll_plaza_on.png'),
      iconOff: AssetImage('assets/images/layers/ic_layer_toll_plaza_off.png'),
      iconWidth: getPlatformSize(29.51),
      iconHeight: getPlatformSize(29.51),
      isChecked: false,
      onClick: null,
    ),
    LayerItemModel(
      text: 'กล้อง CCTV',
      textEn: 'CCTV',
      iconOn: AssetImage('assets/images/layers/ic_layer_cctv_on.png'),
      iconOff: AssetImage('assets/images/layers/ic_layer_cctv_off.png'),
      iconWidth: getPlatformSize(36.23),
      iconHeight: getPlatformSize(30.01),
      isChecked: false,
      onClick: null,
    ),
    LayerItemModel(
      text: 'จุดพักรถ',
      textEn: 'Rest Area',
      iconOn: AssetImage('assets/images/layers/ic_layer_rest_area_on.png'),
      iconOff: AssetImage('assets/images/layers/ic_layer_rest_area_off.png'),
      iconWidth: getPlatformSize(42.15),
      iconHeight: getPlatformSize(40.25),
      isChecked: false,
      onClick: null,
    ),
    LayerItemModel(
      text: 'สถานีตำรวจ',
      textEn: 'Police Station',
      iconOn: AssetImage('assets/images/layers/ic_layer_police_station_on.png'),
      iconOff: AssetImage('assets/images/layers/ic_layer_police_station_off.png'),
      iconWidth: getPlatformSize(35.32),
      iconHeight: getPlatformSize(27.64),
      isChecked: false,
      onClick: null,
    ),
    LayerItemModel(
      text: 'จุดกลับรถ',
      textEn: 'U-Turn',
      iconOn: AssetImage('assets/images/layers/ic_layer_uturn_on.png'),
      iconOff: AssetImage('assets/images/layers/ic_layer_uturn_off.png'),
      iconWidth: getPlatformSize(27.91),
      iconHeight: getPlatformSize(34.59),
      isChecked: false,
      onClick: null,
    ),
    LayerItemModel(
      text: 'Easy Pass',
      textEn: 'Easy Pass',
      iconOn: AssetImage('assets/images/layers/ic_layer_easy_pass_on.png'),
      iconOff: AssetImage('assets/images/layers/ic_layer_easy_pass_off.png'),
      iconWidth: getPlatformSize(42.78),
      iconHeight: getPlatformSize(37.91),
      isChecked: false,
      onClick: null,
    ),
    LayerItemModel(
      text: 'ทางขึ้น',
      textEn: 'In',
      iconOn: AssetImage('assets/images/layers/ic_layer_in_on.png'),
      iconOff: AssetImage('assets/images/layers/ic_layer_in_off.png'),
      iconWidth: getPlatformSize(36.44),
      iconHeight: getPlatformSize(27.11),
      isChecked: false,
      onClick: null,
    ),
  ];

  final Function _onSelectLayerItem;

  @override
  _LayerItemListState createState() => _LayerItemListState();
}

class _LayerItemListState extends State<LayerItemList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: getPlatformSize(70.0),
      child: ListView.separated(
        itemCount: widget._layerItemModelList.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          LayerItemModel selectedLayerItem = widget._layerItemModelList[index];

          return LayerItemView(
            layerItem: selectedLayerItem,
            isFirstItem: index == 0,
            isLastItem: index == widget._layerItemModelList.length - 1,
            onClick: () {
              setState(() {
                selectedLayerItem.isChecked = !selectedLayerItem.isChecked;
                widget._onSelectLayerItem(context, selectedLayerItem);
              });
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
