import 'dart:async';

import 'bloc.dart';

class LoginBloc implements Bloc {
  String _email, _password;

  String get email => _email;
  String get password => _password;

  //กรณี listen stream หลายครั้ง
  //final StreamController<String> _emailController = StreamController<String>.broadcast();
  final StreamController<String> _emailController = StreamController<String>();
  final StreamController<String> _passwordController = StreamController<String>();

  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  void setLoginData(String email, String password) {
    _email = email;
    _emailController.sink.add(email);
    _password = password;
    _passwordController.sink.add(password);
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
}