import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../repository/auth_repository.dart';

class LoginParam {
  final String userName;
  final String password;

  const LoginParam({required this.userName, required this.password});
}

@lazySingleton
class LoginUseCase implements UseCase<DataState<UserCredential>, LoginParam> {
  final AuthRepository _authRepository;

  const LoginUseCase(this._authRepository);

  @override
  Future<DataState<UserCredential>> call(LoginParam param) {
    return _authRepository.login(
        email: param.userName, password: param.password);
  }
}
