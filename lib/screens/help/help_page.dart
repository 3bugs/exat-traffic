import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/components/error_view.dart';
import 'package:exattraffic/models/locale_text.dart';
import 'package:exattraffic/models/language_model.dart';

import 'help_presenter.dart';

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

//List<String> imgList = [
//  'http://www.ezyshine.com/wp-content/uploads/2013/11/online-stores-for-shopping.jpg',
//  'http://kaplp.com/images/placeholder/slider3.jpg',
//  'https://trm.co.ke/wp-content/uploads/2018/10/trmheadersliders.png'
//];

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  LocaleText _title = LocaleText.help();
  int _current = 0;
  HelpPresenter _presenter;

  @override
  void initState() {
    _presenter = HelpPresenter(this);
    _presenter.getHelp();
    super.initState();
  }

  Widget slideBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: map<Widget>(
        _presenter.imgList,
        (index, url) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List child = _presenter.helpModel == null
        ? null
        : map<Widget>(
            _presenter.imgList,
            (index, i) {
              return Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(children: <Widget>[
                    Image.network(
                      i,
                      fit: BoxFit.fill,
                      width: 1000.0,
                      height: double.infinity,
                    ),
                  ]),
                ),
              );
            },
          ).toList();

    return YourScaffold(
      title: _title,
      child: _presenter.error != null
          ? Center(
              child: Consumer<LanguageModel>(
                builder: (context, language, child) {
                  return ErrorView(
                    title: LocaleText.error().ofLanguage(language.lang),
                    text: _presenter.error.message,
                    buttonText: LocaleText.tryAgain().ofLanguage(language.lang),
                    withBackground: true,
                    onClick: _presenter.getHelp(),
                  );
                },
              ),
            )
          : _presenter.helpModel == null
              ? DataLoading()
              : Column(
                  children: [
                    Expanded(
                      child: CarouselSlider(
                        items: child,
                        options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          aspectRatio: 1.8 / 3,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                      ),
                    ),
                    slideBar(),
                  ],
                ),
    );
  }
}
