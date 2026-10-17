part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial({
    @Default(false) bool loginLoading,
    @Default(false) bool saveEmail,
  }) = LoginInitial;

  const factory LoginState.success() = LoginSuccess;
}
