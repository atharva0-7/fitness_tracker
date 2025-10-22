import '../repositories/auth_repository.dart';
import '../../core/models/user_profile.dart';

class AuthUseCases {
  final AuthRepository _authRepository;

  AuthUseCases({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
    required double height,
    required double weight,
  }) async {
    return await _authRepository.register(
      email: email,
      password: password,
      name: name,
      age: age,
      gender: gender,
      height: height,
      weight: weight,
    );
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _authRepository.login(email: email, password: password);
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }

  Future<UserProfile?> getCurrentUser() async {
    return await _authRepository.getCurrentUser();
  }

  Future<bool> isAuthenticated() async {
    return await _authRepository.isAuthenticated();
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> updates) async {
    return await _authRepository.updateProfile(updates);
  }

  Future<void> clearAuth() async {
    await _authRepository.clearAuth();
  }
}
