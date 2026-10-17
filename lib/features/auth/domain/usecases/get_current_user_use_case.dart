import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

@lazySingleton
class GetCurrentUserUseCase implements UseCase<DataState<UserEntity?>, void> {
  final AuthRepository _authRepository;
  const GetCurrentUserUseCase(this._authRepository);

  @override
  Future<DataState<UserEntity?>> call(void param) {
    return _authRepository.getCurrentUser();
  }
}
