import 'package:flutter/material.dart';

import 'package:exattraffic/components/my_progress_indicator.dart';

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
