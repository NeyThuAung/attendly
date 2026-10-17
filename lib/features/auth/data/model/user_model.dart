import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:attendly/features/auth/domain/entity/user_entity.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String email,
    required String name,
    String? profileImageUrl,
    required String role,
    required int createdAtMillis,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      name: entity.name,
      profileImageUrl: entity.profileImageUrl,
      role: entity.role.name,
      createdAtMillis: entity.createdAt.millisecondsSinceEpoch,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      name: name,
      profileImageUrl: profileImageUrl,
      role: role.toLowerCase() == 'admin' ? UserRole.admin : UserRole.user,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
    );
  }
}
