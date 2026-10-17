import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:attendly/core/storage/storage.dart';
import 'package:attendly/features/auth/domain/usecases/login_use_case.dart';
import 'package:attendly/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:attendly/core/services/snack_shower.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AuthenticationCubit _auth;
  final ISnackShower _snackShower;
  final LoginUseCase _loginUseCase;
  final Storage _storage;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  LoginCubit(
    this._auth,
    this._snackShower,
    this._loginUseCase,
    this._storage,
  ) : _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      super(const LoginState.initial()) {
    loadData();
  }

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool _saveEmail = false;

  void loadData() async {
    final email = await _storage.getEmail();
    if (email != null) {
      _saveEmail = true;
      _emailController.text = email;
      emit(LoginInitial(saveEmail: true));
    }
  }

  void onChangeSaveEmployeeNo(bool? save) {
    if (save != null && !save) _storage.removeEmail();
    _saveEmail = save ?? false;
    final currentState = state;
    emit(switch (currentState) {
      LoginInitial() => currentState.copyWith(saveEmail: save ?? false),
      _ => currentState,
    });
  }

  void logIn() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      _snackShower.error(message: 'Please fill in both email and password.');
      return;
    }

    _saveEmail
        ? _storage.saveEmail(_emailController.text.trim())
        : _storage.removeEmail();

    final currentState = state;
    emit(switch (currentState) {
      LoginInitial() => currentState.copyWith(loginLoading: true),
      _ => currentState,
    });

    final res = await _loginUseCase.call(
      LoginParam(
        userName: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );

    res
      ..onSuccess((credential) async {
        final user = credential.user;
        if (user == null) {
          _snackShower.error(message: 'Unable to get user information.');
          emit(switch (state) {
            LoginInitial() => (state as LoginInitial).copyWith(loginLoading: false),
            _ => state,
          });
          return;
        }

        await _auth.resolveAuthentication(user);
        _snackShower.success(message: 'Welcome back!');
        emit(const LoginSuccess());
      })
      ..onError((failure) {
        final currentState = state;
        emit(switch (currentState) {
          LoginInitial() => currentState.copyWith(loginLoading: false),
          _ => currentState,
        });
        _snackShower.error(message: failure.reason);
      });
  }

  @override
  Future<void> close() {
    _emailController.dispose();
    _passwordController.dispose();
    return super.close();
  }
}
