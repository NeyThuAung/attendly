import 'package:injectable/injectable.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecases/get_current_user_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import 'authentication_cubit.dart';

@module
abstract class AuthenticationCubitProvider {
  @preResolve
  @singleton
  Future<AuthenticationCubit> provide(
    GetCurrentUserUseCase getCurrentUserUseCase,
    LogoutUseCase logoutUseCase,
    AuthRepository authRepository,
  ) async {
    final instance = AuthenticationCubit(
      getCurrentUserUseCase,
      logoutUseCase,
      authRepository,
    );
    await instance.loadData();
    return instance;
  }
}
