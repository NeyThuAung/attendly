part of 'register_cubit.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.initial({
    @Default(false) bool registerLoading,
    String? profileImagePath,
  }) = RegisterInitial;

  const factory RegisterState.success() = RegisterSuccess;
}
