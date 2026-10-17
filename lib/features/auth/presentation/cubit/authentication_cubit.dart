import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../../../navigation/index_page.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecases/get_current_user_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;

  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;
  UserRole? get userRole => _currentUser?.role;

  AuthenticationCubit(
    this._getCurrentUserUseCase,
    this._logoutUseCase,
    this._authRepository,
  ) : super(const AuthenticationState.loading());

  StreamSubscription<fb.User?>? _subscription;

  Future<void> loadData() async {
    _subscription = _authRepository.authStateChanges().listen((fbUser) async {
      if (fbUser == null) {
        _currentUser = null;
        emit(const AuthenticationState.unauthenticated());
      } else {
        await resolveAuthentication(fbUser);
      }
    });
  }

  Future<void> resolveAuthentication(fb.User fbUser) async {
    final res = await _getCurrentUserUseCase.call(null);
    res
      ..onSuccess((user) {
        _currentUser = user;
        if (user != null) {
          emit(AuthenticationState.authenticated(user));
        } else {
          emit(const AuthenticationState.unauthenticated());
        }
      })
      ..onError((failure) {
        emit(const AuthenticationState.unauthenticated());
      });
  }

  Future<void> logout() async {
    IndexPage.lastTab = 0;
    await _logoutUseCase.call(null);
    _currentUser = null;
    emit(const AuthenticationState.unauthenticated());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
