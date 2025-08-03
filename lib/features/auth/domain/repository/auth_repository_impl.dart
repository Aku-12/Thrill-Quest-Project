// lib/features/auth/domain/repository/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/core/utils/internet_checker.dart';
import 'package:thrill_quest/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:thrill_quest/features/auth/data/data_source/remote_local_source/auth_remote_datasource.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:thrill_quest/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;
  final AuthLocalDatasource _authLocalDatasource;
  final InternetChecker _internetChecker;

  AuthRepositoryImpl({
    required AuthRemoteDatasource authRemoteDatasource,
    required AuthLocalDatasource authLocalDatasource,
    required InternetChecker internetChecker,
  }) : _authRemoteDatasource = authRemoteDatasource,
       _authLocalDatasource = authLocalDatasource,
       _internetChecker = internetChecker;

  @override
  Future<Either<Failure, void>> createAccount(UserEntity user) async {
    debugPrint('AuthRepositoryImpl: Starting createAccount method.');
    final isConnected = await _internetChecker.isConnected();
    debugPrint(
      'AuthRepositoryImpl: Internet check for createAccount. isConnected: $isConnected',
    );

    if (!isConnected) {
      debugPrint('AuthRepositoryImpl: No internet, returning NetworkFailure.');
      return Left(
        NetworkFailure(
          message: 'No internet connection. Cannot create account online.',
        ),
      );
    }

    try {
      debugPrint(
        'AuthRepositoryImpl: Internet is connected. Attempting remote account creation.',
      );
      await _authRemoteDatasource.createAccount(user);
      debugPrint(
        'AuthRepositoryImpl: Remote account creation successful. Attempting to save user to Hive.',
      );
      await _authLocalDatasource.saveUserToHive(user);
      debugPrint(
        'AuthRepositoryImpl: User successfully saved to Hive. Returning success.',
      );
      return const Right(null);
    } catch (error) {
      debugPrint(
        'AuthRepositoryImpl: Caught an error during online creation or local save: $error',
      );
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, ({UserEntity user, String token})>> loginToAccount(
    String email,
    String password,
  ) async {
    debugPrint(
      'AuthRepositoryImpl: Starting loginToAccount method for email: $email',
    );
    final isConnected = await _internetChecker.isConnected();
    debugPrint(
      'AuthRepositoryImpl: Internet check for loginToAccount. isConnected: $isConnected',
    );

    if (isConnected) {
      debugPrint(
        'AuthRepositoryImpl: Internet is connected. Attempting remote login.',
      );
      try {
        final result = await _authRemoteDatasource.loginToAccount(
          email,
          password,
        );
        debugPrint(
          'AuthRepositoryImpl: Remote login successful. Caching user and token locally.',
        );
        await _authLocalDatasource.saveUserToHive(result.user);
        await _authLocalDatasource.saveToken(result.token);
        debugPrint(
          'AuthRepositoryImpl: User and token successfully cached. Returning success.',
        );
        return Right(result);
      } on NetworkFailure catch (networkError) {
        debugPrint(
          'AuthRepositoryImpl: Caught NetworkFailure. Message: ${networkError.message}. Falling back to cache.',
        );
        final cachedUser = await _authLocalDatasource.getUserFromHive();
        final cachedToken = await _authLocalDatasource.getToken();

        if (cachedUser != null &&
            cachedUser.email == email &&
            cachedToken != null) {
          debugPrint(
            'AuthRepositoryImpl: Found matching cached user. Returning cached data.',
          );
          return Right((user: cachedUser, token: cachedToken));
        } else {
          debugPrint(
            'AuthRepositoryImpl: No matching cached user found. Returning failure.',
          );
          return Left(
            NetworkFailure(
              message:
                  'Login failed. No internet and no matching cached login found.',
            ),
          );
        }
      } catch (error) {
        debugPrint(
          'AuthRepositoryImpl: Caught a non-network error during remote login: $error',
        );
        return Left(ApiFailure(message: error.toString()));
      }
    } else {
      debugPrint(
        'AuthRepositoryImpl: No internet. Skipping remote login and checking local cache.',
      );
      final cachedUser = await _authLocalDatasource.getUserFromHive();
      final cachedToken = await _authLocalDatasource.getToken();

      if (cachedUser != null &&
          cachedUser.email == email &&
          cachedToken != null) {
        debugPrint(
          'AuthRepositoryImpl: Found matching cached user. Returning cached data.',
        );
        return Right((user: cachedUser, token: cachedToken));
      } else {
        debugPrint(
          'AuthRepositoryImpl: No matching cached user found. Returning failure.',
        );
        return Left(
          NetworkFailure(
            message:
                'No internet connection and no matching cached login found.',
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    debugPrint('AuthRepositoryImpl: Starting getUserProfile method.');
    final isConnected = await _internetChecker.isConnected();
    debugPrint(
      'AuthRepositoryImpl: Internet check for getUserProfile. isConnected: $isConnected',
    );
    if (!isConnected) {
      debugPrint(
        'AuthRepositoryImpl: No internet, falling back to cached user.',
      );
      return getCachedUser();
    }
    try {
      debugPrint(
        'AuthRepositoryImpl: Internet is connected. Attempting remote profile fetch.',
      );
      final user = await _authRemoteDatasource.getUserProfile();
      debugPrint(
        'AuthRepositoryImpl: Remote profile fetch successful. Saving to Hive.',
      );
      await _authLocalDatasource.saveUserToHive(user);
      debugPrint(
        'AuthRepositoryImpl: Profile saved to Hive. Returning success.',
      );
      return Right(user);
    } catch (error) {
      debugPrint(
        'AuthRepositoryImpl: Caught an error during remote profile fetch: $error',
      );
      // Optional: Fallback to cache here if you want to.
      return Left(ApiFailure(message: error.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> changePassword({required String userId, required String oldPassword, required String newPassword}) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, UserEntity>> getCachedUser() {
    // TODO: implement getCachedUser
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, String>> getTokenLocally() {
    // TODO: implement getTokenLocally
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> logoutUser() {
    // TODO: implement logoutUser
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> saveTokenLocally(String token) {
    // TODO: implement saveTokenLocally
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> saveUserLocally(UserEntity user) {
    // TODO: implement saveUserLocally
    throw UnimplementedError();
  }
  
 @override
  Future<Either<Failure, UserEntity>> updateProfile(
    UserEntity updatedUser,
    String? imageFilePath,
  ) async {
    final isConnected = await _internetChecker.isConnected();
    if (!isConnected) {
      return Left(
        NetworkFailure(
          message: 'No internet connection. Cannot update profile online.',
        ),
      );
    }
    try {
      final user = await _authRemoteDatasource.updateProfile(
        updatedUser,
        imageFilePath,
      );
      await _authLocalDatasource.saveUserToHive(user);
      return Right(user);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  // ... all other methods with similar debug prints added
}
