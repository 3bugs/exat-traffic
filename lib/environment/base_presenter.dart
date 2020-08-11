import 'package:flutter/material.dart';

abstract class BasePre {}

class BasePresenter<T extends StatefulWidget> {
  State<T> state;
  bool loader = true;

  BasePresenter(this.state);

  setState(Function v) {
    state.setState(v);
  }

  loading() {
    setState(() {
      loader = true;
    });
  }

  dispose() {
    state = null;
  }

  loaded() {
    setState(() {
      loader = false;
    });
  }
}
