import 'package:flutter/material.dart';

import 'package:exattraffic/models/error_model.dart';

abstract class BasePre {}

class BasePresenter<T extends StatefulWidget> {
  State<T> state;
  bool isLoading = false;
  ErrorModel error;
  String loadingMessage;

  BasePresenter(this.state);

  setState(Function v) {
    // ignore: invalid_use_of_protected_member
    state.setState(v);
  }

  dispose() {
    state = null;
  }

  loading() {
    setState(() {
      isLoading = true;
    });
  }

  loaded() {
    setState(() {
      isLoading = false;
    });
  }

  setLoadingMessage(msg) {
    setState(() {
      loadingMessage = msg;
    });
  }

  setError(int errorCode, String errorMessage) {
    setState(() {
      error = ErrorModel(code: errorCode, message: errorMessage);
    });
  }

  clearError() {
    setState(() {
      error = null;
    });
  }
}