import 'package:exattraffic/components/data_loading.dart';
import 'package:flutter/material.dart';

import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';

import 'FAQ_presenter.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["คำถามที่พบบ่อย", "FAQ", "经常问的问题"];
//  bool open = false;
  FAQPresenter _presenter;

  List<bool> open = [];

  Widget _content(){
    return _presenter.faqModel==null?DataLoading():
      Container(
      color: Color(0x09000000),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: getPlatformSize(16),
          vertical: getPlatformSize(10),
        ),
        itemCount: _presenter.faqModel.data.length,
        itemBuilder: (context, index) {
          open.add(false);
          return _datacard(index);
        },
      ),
    );
  }

  Widget _datacard(int index){
    return Card(
      margin: EdgeInsets.only(top: 10),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20),
        color: open[index]?Color(0x11000000): Colors.white,
//                height: 200,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
//                      color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("${_presenter.faqModel.data[index].name}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(

                    onTap: (){
                      setState(() {
                        if(open[index]){
                          open[index] = false;
                        }else {
                          open[index] = true;
                        }
                      });
                    },
                    child: Container(
//                              color: Colors.red,
                      width: 25,
                      child: open[index]?Icon(Icons.keyboard_arrow_up): Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: open[index],
              child: Container(
                child: Column(
                  children: <Widget>[
                    Divider(),
                    Container(
                      child: Text("${_presenter.faqModel.data[index].detail}"),
                      padding: EdgeInsets.only(top: 15,bottom: 15),
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

  @override
  void initState() {
    _presenter = FAQPresenter(this);
    _presenter.getFAQ();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      titleList: _titleList,
      child: _content(),
    );
  }
}
