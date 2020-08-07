import 'package:exattraffic/components/my_progress_indicator.dart';
import 'package:flutter/material.dart';

class DataLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        /*child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),*/
        child: MyProgressIndicator(),
      ),
    );
  }
}
