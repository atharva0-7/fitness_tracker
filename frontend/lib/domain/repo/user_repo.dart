import 'package:dartz/dartz.dart';
import '../entity/user_entity.dart';

abstract class UserRepo {
  Future<Either<String, UserEntity>> getUserProfile(String userId);

  Future<Either<String, UserEntity>> updateUserProfile({
    required String userId,
    required String name,
    String? profileImageUrl,
  });

  Future<Either<String, UserGoalsEntity>> getUserGoals(String userId);

  Future<Either<String, UserGoalsEntity>> updateUserGoals({
    required String userId,
    required UserGoalsEntity goals,
  });

  Future<Either<String, UserPreferencesEntity>> getUserPreferences(
    String userId,
  );

  Future<Either<String, UserPreferencesEntity>> updateUserPreferences({
    required String userId,
    required UserPreferencesEntity preferences,
  });

  Future<Either<String, void>> uploadProfileImage({
    required String userId,
    required String imagePath,
  });

  Future<Either<String, String>> getProfileImageUrl(String userId);

  Future<Either<String, void>> deleteUserProfile(String userId);
}
