import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../repository/auth_repository.dart';

@lazySingleton
class LogoutUseCase implements UseCase<DataState<void>, void> {
  final AuthRepository _authRepository;
  const LogoutUseCase(this._authRepository);

  @override
  Future<DataState<void>> call(void param) {
    return _authRepository.logout();
  }
}
