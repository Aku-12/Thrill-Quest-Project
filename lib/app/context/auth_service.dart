import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
 
class AuthService {
  final _secureStorage = const FlutterSecureStorage();
 
  static const _tokenKey = 'access_token';
  static const _userKey = 'user_data';
 
  Future<void> signIn(UserEntity user, String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
 
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
 
  Future<void> signOut() async {
    await _secureStorage.delete(key: _tokenKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
 
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: _tokenKey);
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
 
    return token != null && userJson != null;
  }
 
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }
 
  Future<UserEntity?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserEntity.fromJson(jsonDecode(userJson));
    }
    return null;
  }
 
  Future<void> updateUser(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}