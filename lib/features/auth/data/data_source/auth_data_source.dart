import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';

abstract interface class IAuthDataSource {
  Future<void> createAccount(UserEntity user);
  Future<({UserEntity user, String token})> loginToAccount(
    String email,
    String password,
  );
  Future<UserEntity> getUserProfile();
  Future<UserEntity> updateProfile(UserEntity updatedUser, String? imageFilePath);

  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });

}
