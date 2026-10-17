import 'dart:async';
import 'package:flutter/foundation.dart';
import '../features/auth/presentation/cubit/authentication_cubit.dart';

class AuthenticationRouterNotifier extends ChangeNotifier {
  AuthenticationRouterNotifier(this._authenticationCubit) {
    _subscription = _authenticationCubit.stream.listen((_) {
      notifyListeners();
    });
  }

  final AuthenticationCubit _authenticationCubit;
  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
