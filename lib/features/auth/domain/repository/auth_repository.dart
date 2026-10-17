import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/core.dart';
import '../entity/user_entity.dart';

abstract interface class AuthRepository {
  Future<DataState<UserCredential>> login(
      {required String email, required String password});

  Future<DataState<UserCredential>> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? profileImagePath,
  });

  Future<DataState<void>> logout();

  Future<DataState<UserEntity?>> getCurrentUser();

  Future<DataState<UserEntity>> getUserDetails(String uid);

  Stream<User?> authStateChanges();
}
