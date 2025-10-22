import 'package:dartz/dartz.dart';
import '../entity/user_entity.dart';

abstract class AuthRepo {
  Future<Either<String, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<String, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<String, void>> logout();

  Future<Either<String, UserEntity?>> getCurrentUser();

  Future<Either<String, void>> sendPasswordResetEmail(String email);

  Future<Either<String, UserEntity>> updateProfile({
    required String name,
    String? profileImageUrl,
  });

  Future<Either<String, void>> deleteAccount();

  Future<Either<String, bool>> isLoggedIn();

  Future<Either<String, String>> getAuthToken();
}
