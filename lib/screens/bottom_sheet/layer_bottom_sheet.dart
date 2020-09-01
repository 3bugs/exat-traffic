import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/screens/home/bloc/bloc.dart';

import 'components/bottom_sheet_scaffold.dart';
import 'components/layer_item.dart';

class LayerBottomSheet extends StatefulWidget {
  LayerBottomSheet({
    @required this.expandPosition,
    @required this.collapsePosition,
    this.child,
  });

  final double expandPosition;
  final double collapsePosition;
  final Widget child;

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
                child: widget.child ?? LayerItemList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LayerItemList extends StatefulWidget {
  LayerItemList();

  @override
  _LayerItemListState createState() => _LayerItemListState();
}

class _LayerItemListState extends State<LayerItemList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previousState, state) {
        return true;
      },
      builder: (context, state) {
        List<CategoryModel> categoryList = state.categoryList;
        //Map<int, bool> categorySelectedMap = state.categorySelectedMap;

        return Container(
          //height: getPlatformSize(70.0),
          child: ListView.separated(
            itemCount: categoryList.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              CategoryModel selectedLayerItem = categoryList[index];

              return LayerItemView(
                layerItem: selectedLayerItem,
                isFirstItem: index == 0,
                isLastItem: index == categoryList.length - 1,
                selected: selectedLayerItem.selected,
                onClick: () {
                  context.bloc<HomeBloc>().add(ClickMarkerLayer(
                    category: selectedLayerItem,
                  ));
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
      },
    );
  }
}
