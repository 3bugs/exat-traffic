//import 'dart:async';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:exattraffic/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/marker_categories/cctv_model.dart';
import 'package:exattraffic/components/tool_item.dart';
import 'package:exattraffic/components/my_progress_indicator.dart';

//import 'package:exattraffic/screens/login/login.dart';
import 'package:exattraffic/components/my_cached_image.dart';

//import 'package:exattraffic/app/app_bloc.dart';
import 'package:exattraffic/models/locale_text.dart';

class CctvDetails extends StatelessWidget {
  CctvDetails(this._cctvModel);

  final CctvModel _cctvModel;

  @override
  Widget build(BuildContext context) {
    return wrapSystemUiOverlayStyle(child: CctvDetailsMain(_cctvModel));
  }
}

LocaleText videoStreamingText = LocaleText.videoStreaming();
LocaleText photoText = LocaleText.photo();

class CctvDetailsMain extends StatefulWidget {
  CctvDetailsMain(this._cctvModel);

  final CctvModel _cctvModel;

  @override
  _CctvDetailsMainState createState() => _CctvDetailsMainState();
}

class _CctvDetailsMainState extends State<CctvDetailsMain> {
  int _checkedToolItemIndex;
  VlcPlayerController _controller;
  bool _isResumingVideo = false;

  void _handleClickTool(BuildContext context, int toolItemIndex) {
    if (toolItemIndex == 2) {
      // เส้นทาง
      return;
    }

    setState(() {
      _checkedToolItemIndex = toolItemIndex;
    });
  }

  Future<Icon> _getFavoriteIcon() async {
    return (await widget._cctvModel.isFavoriteOn(context))
        ? Icon(
            Icons.star,
            color: Constants.App.FAVORITE_ON_COLOR,
            size: getPlatformSize(24.0),
            semanticLabel: 'Favorite',
          )
        : Icon(
            Icons.star_border,
            color: Colors.white,
            size: getPlatformSize(24.0),
            semanticLabel: 'Favorite',
          );
  }

  void _handleClickFavorite(BuildContext context) async {
    LanguageModel language = Provider.of<LanguageModel>(context, listen: false);

    if (await widget._cctvModel.isFavoriteOn(context)) {
      List<DialogButtonModel> dialogButtonList = [
        DialogButtonModel(text: "ไม่ใช่", value: DialogResult.no),
        DialogButtonModel(text: "ใช่", value: DialogResult.yes)
      ];
      DialogResult result = await showMyDialog(
        context,
        LocaleText.confirmDeleteFromFavorite().ofLanguage(language.lang),
        //"ยืนยันลบกล้อง CCTV '${widget._cctvModel.name}' ออกจากรายการโปรด?",
        dialogButtonList,
      );
      if (result == DialogResult.yes) {
        widget._cctvModel.toggleFavorite(context).then((_) {
          setState(() {
            Fluttertoast.showToast(
              msg: LocaleText.deletedFromFavorite().ofLanguage(language.lang),
              //msg: "ลบกล้อง CCTV '${widget._cctvModel.name}' ออกจากรายการโปรดแล้ว",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xFFDEDEDE),
              textColor: Colors.black,
              fontSize: 14.0,
            );
          });
        });
      }
    } else {
      widget._cctvModel.toggleFavorite(context).then((_) {
        setState(() {
          Fluttertoast.showToast(
            msg: LocaleText.savedToFavorite().ofLanguage(language.lang),
            //msg: "เพิ่มกล้อง CCTV '${widget._cctvModel.name}' ในรายการโปรดแล้ว",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xFFDEDEDE),
            textColor: Colors.black,
            fontSize: 14.0,
          );
        });
      });
    }
  }

  void _handleClickClose(BuildContext context) {
    //todo: stop video, etc.
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (_isValidUrl(widget._cctvModel.streamUrl)) {
      _checkedToolItemIndex = 0;
    } else if (_isValidUrl(widget._cctvModel.imageUrl)) {
      _checkedToolItemIndex = 1;
    } else {
      _checkedToolItemIndex = 2;
    }

    if (widget._cctvModel.streamUrl != null) {
      print("***** ${widget._cctvModel.name} - STREAM URL: ${widget._cctvModel.streamUrl}");

      _controller = new VlcPlayerController(
        // Start playing as soon as the video is loaded.
        onInit: () {
          _controller.addListener(() {
            print("***** PLAYING STATE: ${_controller.playingState.toString()}");

            if (_controller.playingState == PlayingState.STOPPED) {
              _isResumingVideo = true;
              Future.delayed(Duration(seconds: 1), () {
                _controller.play();
              });
            } else if (_controller.playingState == PlayingState.PLAYING) {
              _isResumingVideo = false;
            }

            // rebuild ใหม่ทุกครั้งเมื่อสถานะของ video player เปลี่ยน
            try {
              // เกิด error ตรงนี้ หลังจากกด back ออกจากหน้า cctv details
              setState(() {});
            } catch (_) {}
          });
          _controller.play();
        },
      );
    } else {
      print("***** ${widget._cctvModel.name} - STREAM URL is NULL !");
    }
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    return url != null && url.trim().length > 7; // อย่างน้อย "http://"
  }

  @override
  Widget build(BuildContext context) {
    final String streamUrl = widget._cctvModel.streamUrl;
    final String imageUrl = widget._cctvModel.imageUrl;

    return Scaffold(
      appBar: null,
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getPlatformSize(0.0),
              //getPlatformSize(Constants.CctvPlayerScreen.HORIZONTAL_MARGIN),
              vertical: getPlatformSize(0.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: getPlatformSize(10.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          hoverColor: Color(0xFF999999),
                          splashColor: Color(0xFF999999),
                          highlightColor: Color(0xFF999999),
                          focusColor: Color(0xFF999999),
                          onTap: () => _handleClickFavorite(context),
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          child: Container(
                            width: getPlatformSize(36.0),
                            height: getPlatformSize(36.0),
                            //padding: EdgeInsets.all(getPlatformSize(15.0)),
                            child: Center(
                              child: FutureBuilder(
                                future: _getFavoriteIcon(),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  return snapshot.hasData ? snapshot.data : SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: getPlatformSize(10.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          hoverColor: Color(0xFF999999),
                          splashColor: Color(0xFF999999),
                          highlightColor: Color(0xFF999999),
                          focusColor: Color(0xFF999999),
                          onTap: () => _handleClickClose(context),
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          child: Container(
                            width: getPlatformSize(36.0),
                            height: getPlatformSize(36.0),
                            //padding: EdgeInsets.all(getPlatformSize(15.0)),
                            child: Center(
                              child: Image(
                                image: AssetImage('assets/images/cctv_details/ic_close_cctv.png'),
                                width: getPlatformSize(13.5),
                                height: getPlatformSize(13.5),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getPlatformSize(16.0),
                ),
                Center(
                  child: Consumer<LanguageModel>(
                    builder: (context, language, child) {
                      return Text(
                        widget._cctvModel.name,
                        style: getTextStyle(
                          language.lang,
                          sizeTh: Constants.Font.BIGGER_SIZE_TH,
                          sizeEn: Constants.Font.BIGGER_SIZE_EN,
                          color: Colors.white,
                          isBold: true,
                          //heightEn: 1.5 / 0.9,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: getPlatformSize(25.0),
                ),
                IndexedStack(
                  index: _checkedToolItemIndex,
                  children: <Widget>[
                    _isValidUrl(streamUrl)
                        ? AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                VlcPlayer(
                                  aspectRatio: 4 / 3,
                                  url: streamUrl,
                                  controller: _controller,
                                  placeholder: Center(child: MyProgressIndicator()),
                                ),
                                Visibility(
                                  visible: !_controller.initialized ||
                                      _controller.playingState == null ||
                                      _isResumingVideo,
                                  child: Center(child: MyProgressIndicator()),
                                ),
                                Visibility(
                                  visible:
                                      false, //_controller.playingState == PlayingState.STOPPED,
                                  child: Consumer<LanguageModel>(
                                    builder: (context, language, child) {
                                      return MyButton(
                                        text: LocaleText.errorPleaseTryAgain()
                                            .ofLanguage(language.lang),
                                        onClick: () {
                                          _controller.play();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    _isValidUrl(imageUrl)
                        ? AspectRatio(
                            aspectRatio: 4 / 3,
                            child: MyCachedImage(
                              imageUrl: imageUrl,
                              progressIndicatorSize: ProgressIndicatorSize.large,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),

                /*Container(
                  height: getPlatformSize(240.0),
                  margin: EdgeInsets.symmetric(
                    horizontal: getPlatformSize(Constants.CctvPlayerScreen.HORIZONTAL_MARGIN),
                    vertical: getPlatformSize(0.0),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(
                      color: Colors.yellowAccent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(getPlatformSize(10.0)),
                    ),
                  ),
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/images/cctv_details/ic_playback.png'),
                      width: getPlatformSize(89.0),
                      height: getPlatformSize(89.0),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),*/
                SizedBox(
                  height: getPlatformSize(28.0),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getPlatformSize(Constants.CctvPlayerScreen.HORIZONTAL_MARGIN),
                  ),
                  child: Consumer<LanguageModel>(
                    builder: (context, language, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _isValidUrl(streamUrl)
                              ? ToolItem(
                                  videoStreamingText.ofLanguage(language.lang),
                                  AssetImage('assets/images/cctv_details/ic_video.png'),
                                  getPlatformSize(30.79),
                                  getPlatformSize(25.51),
                                  this._checkedToolItemIndex == 0,
                                  () => this._handleClickTool(context, 0),
                                )
                              : SizedBox.shrink(),
                          _isValidUrl(imageUrl)
                              ? ToolItem(
                                  photoText.ofLanguage(language.lang),
                                  AssetImage('assets/images/cctv_details/ic_picture.png'),
                                  getPlatformSize(23.67),
                                  getPlatformSize(20.06),
                                  this._checkedToolItemIndex == 1,
                                  () => this._handleClickTool(context, 1),
                                )
                              : SizedBox.shrink(),
                          /*ToolItem(
                          'เส้นทาง',
                          AssetImage('assets/images/cctv_details/ic_route.png'),
                          getPlatformSize(27.06),
                          getPlatformSize(35.21),
                          this._checkedToolItemIndex == 2,
                          () => this._handleClickTool(context, 2),
                        ),*/
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
