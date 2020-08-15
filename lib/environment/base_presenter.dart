import 'package:flutter/material.dart';

abstract class BasePre {}

class BasePresenter<T extends StatefulWidget> {
  State<T> state;
  bool isLoading = false;

  BasePresenter(this.state);

  setState(Function v) {
    state.setState(v);
  }

  loading() {
    setState(() {
      isLoading = true;
    });
  }

  dispose() {
    state = null;
  }

  loaded() {
    setState(() {
      isLoading = false;
    });
  }
}
