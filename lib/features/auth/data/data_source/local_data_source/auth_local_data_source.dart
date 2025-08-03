import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thrill_quest/core/network/hive_service.dart';
import 'package:thrill_quest/features/auth/data/model/user_hive_model.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';

class AuthLocalDatasource {
  final HiveService _hiveService;
  final FlutterSecureStorage _secureStorage;

  static const String _tokenKey = 'auth_token';

  AuthLocalDatasource({
    required HiveService hiveService,
    required FlutterSecureStorage secureStorage,
  }) : _hiveService = hiveService,
       _secureStorage = secureStorage;

  Future<void> saveUserToHive(UserEntity user) async {
    final userHiveModel = UserHiveModel.fromEntity(user);
    await _hiveService.saveUser(userHiveModel);
  }

  Future<UserEntity?> getUserFromHive() async {
    final userHiveModel = await _hiveService.getUser();
    return userHiveModel?.toEntity();
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> clearAllAuthData() async {
    await _hiveService.clearAuthData();
    await _secureStorage.delete(key: _tokenKey);
  }
}
