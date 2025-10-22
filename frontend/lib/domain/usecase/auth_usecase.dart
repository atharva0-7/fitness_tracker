import 'package:dartz/dartz.dart';
import '../entity/user_entity.dart';
import '../repo/auth_repo.dart';

class AuthUseCase {
  final AuthRepo _authRepo;

  AuthUseCase(this._authRepo);

  Future<Either<String, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _authRepo.register(
      email: email,
      password: password,
      name: name,
    );
  }

  Future<Either<String, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    return await _authRepo.login(email: email, password: password);
  }

  Future<Either<String, void>> logout() async {
    return await _authRepo.logout();
  }

  Future<Either<String, UserEntity?>> getCurrentUser() async {
    return await _authRepo.getCurrentUser();
  }

  Future<Either<String, void>> sendPasswordResetEmail(String email) async {
    return await _authRepo.sendPasswordResetEmail(email);
  }

  Future<Either<String, UserEntity>> updateProfile({
    required String name,
    String? profileImageUrl,
  }) async {
    return await _authRepo.updateProfile(
      name: name,
      profileImageUrl: profileImageUrl,
    );
  }

  Future<Either<String, void>> deleteAccount() async {
    return await _authRepo.deleteAccount();
  }

  Future<Either<String, bool>> isLoggedIn() async {
    return await _authRepo.isLoggedIn();
  }

  Future<Either<String, String>> getAuthToken() async {
    return await _authRepo.getAuthToken();
  }
}
