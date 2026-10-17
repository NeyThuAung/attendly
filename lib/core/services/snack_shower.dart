import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../navigation/navigation_key_provider.dart';
import '../../shared/components/prompt/snack_gravity.dart';

abstract interface class ISnackShower {
  void info({required String message, SnackGravity gravity = SnackGravity.top});
  void error({required String message, SnackGravity gravity = SnackGravity.top});
  void success({required String message, SnackGravity gravity = SnackGravity.top});
}

@LazySingleton(as: ISnackShower)
class SnackShower implements ISnackShower {
  final INavigationKeyProvider _navigationKeyProvider;

  const SnackShower(this._navigationKeyProvider);

  BuildContext? get _context => _navigationKeyProvider.scaffoldContext;

  @override
  void error({
    required String message,
    SnackGravity gravity = SnackGravity.top,
  }) {
    if (_context == null) return;
    Snacks.error(_context!, message: message, gravity: gravity);
  }

  @override
  void info({
    required String message,
    SnackGravity gravity = SnackGravity.top,
  }) {
    if (_context == null) return;
    Snacks.info(_context!, message: message, gravity: gravity);
  }

  @override
  void success({
    required String message,
    SnackGravity gravity = SnackGravity.top,
  }) {
    if (_context == null) return;
    Snacks.success(_context!, message: message, gravity: gravity);
  }
}
