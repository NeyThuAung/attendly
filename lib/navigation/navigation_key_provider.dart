import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract interface class INavigationKeyProvider {
  GlobalKey<NavigatorState> get globalKey;
  BuildContext? scaffoldContext;
}

@Singleton(as: INavigationKeyProvider)
class NavigationKeyProvider implements INavigationKeyProvider {
  late final _globalKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get globalKey => _globalKey;

  @override
  BuildContext? scaffoldContext;
}
