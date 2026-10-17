import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/user_entity.dart';

part 'authentication_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.loading() = AuthenticationLoading;
  const factory AuthenticationState.authenticated(UserEntity user) = Authenticated;
  const factory AuthenticationState.unauthenticated() = AuthenticationUnauthenticated;
}
