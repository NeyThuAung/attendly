import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class RegisterParam {
  final String email;
  final String password;
  final String name;
  final UserRole role;
  final String? profileImagePath;

  const RegisterParam({
    required this.email,
    required this.password,
    required this.name,
    this.role = UserRole.user,
    this.profileImagePath,
  });
}

@lazySingleton
class RegisterUseCase implements UseCase<DataState<UserCredential>, RegisterParam> {
  final AuthRepository _authRepository;
  const RegisterUseCase(this._authRepository);

  @override
  Future<DataState<UserCredential>> call(RegisterParam param) {
    return _authRepository.register(
      email: param.email,
      password: param.password,
      name: param.name,
      role: param.role,
      profileImagePath: param.profileImagePath,
    );
  }
}
