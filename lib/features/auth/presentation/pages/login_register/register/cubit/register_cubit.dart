import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import 'package:attendly/core/services/snack_shower.dart';
import 'package:attendly/features/auth/domain/entity/user_entity.dart';
import 'package:attendly/features/auth/domain/usecases/register_use_case.dart';
import 'package:attendly/features/auth/presentation/cubit/authentication_cubit.dart';

part 'register_cubit.freezed.dart';
part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final AuthenticationCubit _auth;
  final ISnackShower _snackShower;
  final RegisterUseCase _registerUseCase;
  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController;

  RegisterCubit(
    this._auth,
    this._snackShower,
    this._registerUseCase,
  ) : _nameController = TextEditingController(),
      _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmPasswordController = TextEditingController(),
      super(const RegisterState.initial());

  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController => _confirmPasswordController;

  UserRole _selectedRole = UserRole.user;
  UserRole get selectedRole => _selectedRole;

  void setRole(UserRole role) {
    _selectedRole = role;
    emit(state);
  }

  void pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final s = state;
      if (s is RegisterInitial) {
        emit(s.copyWith(profileImagePath: pickedFile.path));
      }
    }
  }

  void register() async {
    final s = state;
    String? imagePath;
    if (s is RegisterInitial) {
      imagePath = s.profileImagePath;
      emit(s.copyWith(registerLoading: true));
    }

    final res = await _registerUseCase.call(
      RegisterParam(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        role: _selectedRole,
        profileImagePath: imagePath,
      ),
    );

    res
      ..onSuccess((credential) async {
        final user = credential.user;
        if (user == null) {
          _snackShower.error(message: 'Registration failed.');
          emit(RegisterInitial(registerLoading: false, profileImagePath: imagePath));
          return;
        }
        await _auth.resolveAuthentication(user);
        emit(const RegisterSuccess());
      })
      ..onError((failure) {
        emit(RegisterInitial(registerLoading: false, profileImagePath: imagePath));
        _snackShower.error(message: failure.reason);
      });
  }

  @override
  Future<void> close() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    return super.close();
  }
}
