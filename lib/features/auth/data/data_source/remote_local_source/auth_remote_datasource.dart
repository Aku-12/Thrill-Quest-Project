import 'package:dio/dio.dart';
import 'package:thrill_quest/app/constant/api/api_endpoints.dart';
import 'package:thrill_quest/core/network/api_service.dart';
import 'package:thrill_quest/features/auth/data/data_source/auth_data_source.dart';
import 'package:thrill_quest/features/auth/data/model/user_api_model.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';

class AuthRemoteDatasource implements IAuthDataSource {
  final ApiService _apiService;

  AuthRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> createAccount(UserEntity user) async {
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('User registration failed: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      throw Exception('User registration failed: ${error.message}');
    } catch (error) {
      throw Exception('User registration failed: $error');
    }
  }

  @override
  Future<String> loginToAccount(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final authToken = response.data['token'];
        return authToken;
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      throw Exception('Login failed: ${error.message}');
    } catch (error) {
      throw Exception('Login failed: $error');
    }
  }
}
