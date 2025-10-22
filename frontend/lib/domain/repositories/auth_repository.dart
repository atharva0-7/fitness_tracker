import '../../core/models/user_profile.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
    required double height,
    required double weight,
  });

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserProfile?> getCurrentUser();

  Future<bool> isAuthenticated();

  Future<UserProfile> updateProfile(Map<String, dynamic> updates);

  Future<void> clearAuth();
}
