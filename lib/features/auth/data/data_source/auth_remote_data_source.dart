import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/firestore_config.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../domain/entity/user_entity.dart';
import '../model/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserCredential> login(
      {required String email, required String password});

  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? profileImagePath,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<UserModel> getUserDetails(String uid);

  Stream<User?> authStateChanges();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final ICloudinaryService _cloudinaryService;

  const AuthRemoteDataSourceImpl(
    this._firebaseAuth,
    this._firestore,
    this._cloudinaryService,
  );

  @override
  Future<UserCredential> login(
      {required String email, required String password}) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? profileImagePath,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception('Failed to create user credential.');

    String? downloadUrl;
    if (profileImagePath != null && profileImagePath.isNotEmpty) {
      downloadUrl = await _cloudinaryService.uploadImage(profileImagePath);
    }

    final userModel = UserModel(
      uid: user.uid,
      email: email,
      name: name,
      profileImageUrl: downloadUrl,
      role: role.name,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
    );

    await _firestore
        .collection(FirestoreConfig.users)
        .doc(user.uid)
        .set(userModel.toJson());

    return credential;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return await getUserDetails(user.uid);
  }

  @override
  Future<UserModel> getUserDetails(String uid) async {
    final doc =
        await _firestore.collection(FirestoreConfig.users).doc(uid).get();
    if (!doc.exists) {
      throw Exception('User profile not found in Firestore.');
    }
    return UserModel.fromJson(doc.data()!);
  }

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();
}
