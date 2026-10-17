import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<DataState<UserCredential>> login(
      {required String email, required String password}) async {
    try {
      final credential =
          await _remoteDataSource.login(email: email, password: password);
      return Success(credential);
    } on FirebaseException catch (e) {
      final remoteEx = e.toRemoteException();
      return Failed(remoteEx.toFailure());
    } catch (e) {
      return Failed(UnknownNetworkFailure(e.toString()));
    }
  }

  @override
  Future<DataState<UserCredential>> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? profileImagePath,
  }) async {
    try {
      final credential = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        role: role,
        profileImagePath: profileImagePath,
      );
      return Success(credential);
    } on FirebaseException catch (e) {
      final remoteEx = e.toRemoteException();
      return Failed(remoteEx.toFailure());
    } catch (e) {
      return Failed(UnknownNetworkFailure(e.toString()));
    }
  }

  @override
  Future<DataState<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Success(null);
    } catch (e) {
      return Failed(UnknownNetworkFailure(e.toString()));
    }
  }

  @override
  Future<DataState<UserEntity?>> getCurrentUser() async {
    try {
      final model = await _remoteDataSource.getCurrentUser();
      return Success(model?.toEntity());
    } on FirebaseException catch (e) {
      final remoteEx = e.toRemoteException();
      return Failed(remoteEx.toFailure());
    } catch (e) {
      return Failed(UnknownNetworkFailure(e.toString()));
    }
  }

  @override
  Future<DataState<UserEntity>> getUserDetails(String uid) async {
    try {
      final model = await _remoteDataSource.getUserDetails(uid);
      return Success(model.toEntity());
    } on FirebaseException catch (e) {
      final remoteEx = e.toRemoteException();
      return Failed(remoteEx.toFailure());
    } catch (e) {
      return Failed(UnknownNetworkFailure(e.toString()));
    }
  }

  @override
  Stream<User?> authStateChanges() => _remoteDataSource.authStateChanges();
}
