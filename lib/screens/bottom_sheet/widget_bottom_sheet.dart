import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';

import 'components/bottom_sheet_scaffold.dart';

class WidgetBottomSheet extends StatefulWidget {
  WidgetBottomSheet({
    @required this.title,
    @required this.dataList,
    @required this.onClickItem,
    @required this.expandPosition,
    @required this.collapsePosition,
  });

  final String title;
  final List<TextImageModel> dataList;
  final Function onClickItem;
  final double expandPosition;
  final double collapsePosition;

  @override
  _WidgetBottomSheetState createState() => _WidgetBottomSheetState();
}

class _WidgetBottomSheetState extends State<WidgetBottomSheet> {
  final GlobalKey<BottomSheetScaffoldState> _keyBottomSheetScaffold = GlobalKey();

  //AssetImage('assets/images/home/express_way_chalerm.jpg')
  /*List<TextImageModel> _dataList = [
    TextImageModel(
      text: "ทดสอบ",
      assetImage: AssetImage('assets/images/home/express_way_chalerm.jpg'),
    ),
    TextImageModel(
      text: "ทดสอบ",
      assetImage: AssetImage('assets/images/home/express_way_chalerm.jpg'),
    ),
    TextImageModel(
      text: "ทดสอบ",
      assetImage: AssetImage('assets/images/home/express_way_chalerm.jpg'),
    ),
    TextImageModel(
      text: "ทดสอบ",
      assetImage: AssetImage('assets/images/home/express_way_chalerm.jpg'),
    ),
    TextImageModel(
      text: "ทดสอบ",
      assetImage: AssetImage('assets/images/home/express_way_chalerm.jpg'),
    ),
    TextImageModel(
      text: "ทดสอบ",
      assetImage: AssetImage('assets/images/home/express_way_chalerm.jpg'),
    ),
  ];*/

  @override
  void initState() {
    super.initState();
  }

  void _handleChangeSize(bool sheetExpanded) {}

  void _handleClickItem(TextImageModel item) {
    if (widget.onClickItem != null) {
      widget.onClickItem(item);
    }
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
            top: getPlatformSize(10.0),
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
                    height: getPlatformSize(42.0),
                  ),
                  Expanded(
                    child: Center(
                      child: Consumer<LanguageModel>(
                        builder: (context, language, child) {
                          return Text(
                            widget.title,
                            style: getTextStyle(language.lang, isBold: true),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getPlatformSize(4.0)),
              Expanded(
                child: ItemList(
                  dataList: widget.dataList,
                  onClickItem: _handleClickItem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemList extends StatefulWidget {
  ItemList({@required this.dataList, @required this.onClickItem});

  final List<TextImageModel> dataList;
  final Function onClickItem;

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getPlatformSize(120.0),
      child: ListView.separated(
        itemCount: widget.dataList.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          TextImageModel item = widget.dataList[index];

          return ItemView(
            item: item,
            isFirstItem: index == 0,
            isLastItem: index == widget.dataList.length - 1,
            onClick: () => widget.onClickItem(item),
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

class TextImageModel {
  final String text;
  final Widget widget;
  /*final AssetImage assetImage;
  final String imageUrl;*/

  TextImageModel({
    @required this.text,
    @required this.widget,
    /*this.assetImage,
    this.imageUrl,*/
  });
}

class ItemView extends StatelessWidget {
  ItemView({
    @required this.item,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.onClick,
  });

  final TextImageModel item;
  final bool isFirstItem;
  final bool isLastItem;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.all(
          Radius.circular(getPlatformSize(12.0)),
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: getPlatformSize(isFirstItem ? 20.0 : 10.0),
            right: getPlatformSize(isLastItem ? 20.0 : 10.0),
            top: getPlatformSize(2.0),
            bottom: getPlatformSize(2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                ),
                child: SizedBox(
                  width: getPlatformSize(122.0),
                  height: getPlatformSize(78.0),
                  child: this.item.widget,
                ),
                /*child: Image(
                  image: this.item.assetImage,
                  width: getPlatformSize(122.0),
                  height: getPlatformSize(78.0),
                  fit: BoxFit.cover,
                ),*/
              ),
              Container(
                padding: EdgeInsets.only(
                  top: getPlatformSize(10.0),
                ),
                child: Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    return Text(
                      this.item.text,
                      style: getTextStyle(
                        language.lang,
                        sizeTh: Constants.Font.SMALLER_SIZE_TH,
                        sizeEn: Constants.Font.SMALLER_SIZE_EN,
                        heightTh: 1.0,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
