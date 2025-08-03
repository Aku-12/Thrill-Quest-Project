import 'dart:io'; 
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:thrill_quest/app/constant/api/api_endpoints.dart';
import 'package:thrill_quest/core/error/failure.dart';
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
      // A 201 (Created) or 200 (OK) status is typically a success.
      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      } else {
        throw Exception('User registration failed: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      // Try to get a more specific error message from the backend response.
      final errorMessage = error.response?.data['message'] ?? error.message;
      throw Exception('User registration failed: $errorMessage');
    } catch (error) {
      throw Exception(
        'An unexpected error occurred during registration: $error',
      );
    }
  }

  @override
  Future<({UserEntity user, String token})> loginToAccount(
    String email,
    String password,
  ) async {
    try {
      debugPrint('AuthRemoteDatasource: Attempting login for email: $email');
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      debugPrint(
        'AuthRemoteDatasource: Login Response Status Code: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic> &&
            response.data['success'] == false) {
          final errorMessage =
              response.data['message'] ?? 'Login failed due to server logic.';
          debugPrint(
            'AuthRemoteDatasource: Server reported login success: false. Message: $errorMessage',
          );
          throw ApiFailure(message: errorMessage);
        }
        
        final userData = response.data['data'];
        final tokenData = response.data['token'];

        if (userData == null || userData is! Map<String, dynamic>) {
          throw ApiFailure(message: 'Login response missing valid user data.');
        }
        if (tokenData == null || tokenData is! String) {
          throw ApiFailure(message: 'Login response missing token.');
        }

        final userEntity = UserEntity.fromJson(userData);
        final token = tokenData;

        debugPrint(
          'AuthRemoteDatasource: Successfully parsed UserEntity: ${userEntity.email}',
        );
        debugPrint('AuthRemoteDatasource: Successfully parsed Token: $token');

        return (user: userEntity, token: token);
      } else {
        throw ApiFailure(message: 'Login failed: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      debugPrint('AuthRemoteDatasource: DioException during login: ${error.message}');
      debugPrint('AuthRemoteDatasource: DioException Response Data: ${error.response?.data}');

      // This is the CRITICAL fix: A single if-else-if structure that guarantees a throw.
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.unknown ||
          error.type == DioExceptionType.connectionError) {
        throw NetworkFailure(message: 'Login failed due to connection issues. Please check your internet connection.');
      } else if (error.response != null) {
        // This handles all server-side errors (400, 401, 500, etc.)
        final errorMessage = error.response?.data['message'] ?? 'An API error occurred.';
        throw ApiFailure(message: errorMessage);
      } else {
        // This is a catch-all for any other unexpected DioExceptions.
        throw CacheFailure(message: 'A general Dio error occurred: ${error.message}');
      }
    } catch (error) {
      debugPrint('AuthRemoteDatasource: General error during login: $error');
      // For any other unexpected errors.
      throw CacheFailure(message: 'An unexpected error occurred: $error');
    }
  }

  @override
  Future<void> changePassword({
    required String userId, // Note: userId might not be needed if using tokens
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // The backend can identify the user via the auth token,
      // so sending the userId is often redundant.
      final response = await _apiService.dio.post(
        ApiEndpoints
            .changePassword, // Assuming an endpoint like '/auth/change-password'
        data: {'oldPassword': oldPassword, 'newPassword': newPassword},
      );

      if (response.statusCode == 200) {
        debugPrint('Password changed successfully.');
        return;
      } else {
        throw Exception('Failed to change password: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      final errorMessage = error.response?.data['message'] ?? error.message;
      throw Exception('Failed to change password: $errorMessage');
    } catch (error) {
      throw Exception('An unexpected error occurred: $error');
    }
  }

  @override
  Future<UserEntity> getUserProfile() async {
    try {
      // This request should be authenticated by the token passed in the headers
      // by the ApiService interceptor.
      final response = await _apiService.dio.get(
        ApiEndpoints
            .getUserProfile, // Assuming an endpoint like '/auth/profile'
      );

      if (response.statusCode == 200) {
        final userData = response.data['data'];
        if (userData != null && userData is Map<String, dynamic>) {
          return UserEntity.fromJson(userData);
        } else {
          throw Exception('Invalid profile data format received from server.');
        }
      } else {
        throw Exception(
          'Failed to fetch user profile: ${response.statusMessage}',
        );
      }
    } on DioException catch (error) {
      final errorMessage = error.response?.data['message'] ?? error.message;
      throw Exception('Failed to fetch user profile: $errorMessage');
    } catch (error) {
      throw Exception(
        'An unexpected error occurred while fetching profile: $error',
      );
    }
  }

  @override
  Future<UserEntity> updateProfile(
    UserEntity updatedUser,
    String? imageFilePath,
  ) async {
    try {
      final userId = updatedUser.id;
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID is required to update profile.');
      }

      final Map<String, dynamic> userDataMap = updatedUser.toJson();
      final FormData formData = FormData();

      userDataMap.forEach((key, value) {
        if (key != 'id' && value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
          debugPrint('Added form field: $key = $value');
        }
      });

      if (imageFilePath != null && imageFilePath.isNotEmpty) {
        final file = File(imageFilePath);
        if (await file.exists()) {
          // Determine the MIME type based on file extension (a common heuristic)
          // You might need a more robust package like 'mime' for better detection
          String? mimeType;
          String extension = file.path.split('.').last.toLowerCase();
          switch (extension) {
            case 'jpg':
            case 'jpeg':
              mimeType = 'image/jpeg';
              break;
            case 'png':
              mimeType = 'image/png';
              break;
            case 'gif':
              mimeType = 'image/gif';
              break;
            case 'webp':
              mimeType = 'image/webp';
              break;
            default:
              mimeType =
                  'application/octet-stream'; // Fallback for unknown types
              debugPrint(
                'Warning: Unknown image extension "$extension". Defaulting to $mimeType',
              );
          }

          formData.files.add(
            MapEntry(
              "profileImage",
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
                contentType: MediaType.parse(mimeType),
              ),
            ),
          );
          debugPrint(
            'Added image file: ${file.path} with MIME type: $mimeType',
          );
        } else {
          debugPrint(
            'Warning: Image file not found at $imageFilePath. Skipping image upload.',
          );
        }
      }

      final response = await _apiService.dio.put(
        ApiEndpoints.updateProfile(userId),
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      if (response.statusCode == 200) {
        final userData = response.data['data'];
        if (userData != null && userData is Map<String, dynamic>) {
          debugPrint('Profile update successful. Received data: $userData');
          return UserEntity.fromJson(userData);
        } else {
          throw Exception(
            'Invalid updated user data format received from server.',
          );
        }
      } else {
        throw Exception(
          'Profile update failed: ${response.statusMessage ?? 'Unknown error'}',
        );
      }
    } on DioException catch (error) {
      debugPrint('DioException during profile update: ${error.message}');
      debugPrint('DioException Response Data: ${error.response?.data}');
      final errorMessage =
          error.response?.data['message'] ??
          'An error occurred during profile update.';
      if (error.response?.data is Map<String, dynamic> &&
          error.response!.data.containsKey('message')) {
        throw Exception(
          'Failed to update profile: ${error.response!.data['message']}',
        );
      }
      throw Exception('Failed to update profile: $errorMessage');
    } catch (error) {
      debugPrint('General error during profile update: $error');
      throw Exception(
        'An unexpected error occurred during profile update: $error',
      );
    }
  }
}
