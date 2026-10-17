import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/storage_config.dart';
import '../../features/auth/domain/entity/user_entity.dart';
import '../../features/auth/data/model/user_model.dart';

abstract class Storage {
  Future<String?> getEmail();
  Future<void> saveEmail(String username);
  Future<void> removeEmail();
  Future<UserEntity?> getSavedUserInfo();
  Future<void> saveUserInfo(UserEntity user);
  Future<void> torchAllLocalUserData();
  Future<bool> getIsDarkMode();
  Future<void> saveIsDarkMode(bool isDark);
}

@LazySingleton(as: Storage)
class StorageImpl implements Storage {
  final SharedPreferences _prefs;

  static const String _isDarkModeKey = 'is_dark_mode';

  const StorageImpl(this._prefs);

  @override
  Future<void> saveEmail(String username) async {
    await _prefs.setString(StorageConfig.username, username);
  }

  @override
  Future<String?> getEmail() async {
    return _prefs.getString(StorageConfig.username);
  }

  @override
  Future<void> removeEmail() async {
    await _prefs.remove(StorageConfig.username);
  }

  @override
  Future<UserEntity?> getSavedUserInfo() async {
    final source = _prefs.getString(StorageConfig.userInfoKey);
    if (source?.isNotEmpty == true) {
      final userModel = UserModel.fromJson(jsonDecode(source!));
      return userModel.toEntity();
    }
    return null;
  }

  @override
  Future<void> saveUserInfo(UserEntity user) async {
    await _prefs.setString(
      StorageConfig.userInfoKey,
      jsonEncode(UserModel.fromEntity(user).toJson()),
    );
  }

  @override
  Future<void> torchAllLocalUserData() async {
    await _prefs.remove(StorageConfig.userInfoKey);
  }

  @override
  Future<bool> getIsDarkMode() async {
    return _prefs.getBool(_isDarkModeKey) ?? false;
  }

  @override
  Future<void> saveIsDarkMode(bool isDark) async {
    await _prefs.setBool(_isDarkModeKey, isDark);
  }
}
