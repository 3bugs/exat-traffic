import 'package:flutter/material.dart';

import 'bloc.dart';

class MyBlocProvider<T extends Bloc> extends StatefulWidget {
  final Widget child;
  final T bloc;

  const MyBlocProvider({
    Key key,
    @required this.bloc,
    @required this.child,
  }) : super(key: key);

  static T of<T extends Bloc>(BuildContext context) {
    final type = _providerType<MyBlocProvider<T>>();
    //final BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    final MyBlocProvider<T> provider = context.findAncestorWidgetOfExactType();
    return provider.bloc;
  }

  static Type _providerType<T>() => T;

  @override
  State createState() => _BlocProviderState();
}

class _BlocProviderState extends State<MyBlocProvider> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
