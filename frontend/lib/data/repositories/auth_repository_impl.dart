import '../../domain/repositories/auth_repository.dart';
import '../../core/models/user_profile.dart';
import '../data_sources/remote_data_source.dart';
import '../data_sources/local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required LocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
    required double height,
    required double weight,
  }) async {
    try {
      final result = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        age: age,
        gender: gender,
        height: height,
        weight: weight,
      );

      if (result['success'] == true && result['data'] != null) {
        final userData = result['data'];
        final user = UserProfile.fromJson(userData);

        // Save to local storage
        await _localDataSource.saveUserProfile(user);
        await _localDataSource.saveAuthToken(userData['access_token']);
        await _localDataSource.saveUserData(userData);
      }

      return result;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      if (result['success'] == true && result['data'] != null) {
        final userData = result['data'];
        final user = UserProfile.fromJson(userData);

        // Save to local storage
        await _localDataSource.saveUserProfile(user);
        await _localDataSource.saveAuthToken(userData['access_token']);
        await _localDataSource.saveUserData(userData);
      }

      return result;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (e) {
      // Ignore logout errors
    } finally {
      await _localDataSource.clearAuthData();
    }
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    try {
      // Try to get from local storage first
      final localUser = await _localDataSource.getUserProfile();
      if (localUser != null) {
        return localUser;
      }

      // If not in local storage, try to get from remote
      final remoteUser = await _remoteDataSource.getUserProfile();
      await _localDataSource.saveUserProfile(remoteUser);
      return remoteUser;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await _localDataSource.getAuthToken();
      if (token == null) return false;

      // Set token in remote data source
      _remoteDataSource.setAuthToken(token);

      // Try to make an authenticated request to verify token
      await _remoteDataSource.getUserProfile();
      return true;
    } catch (e) {
      // Token is invalid, clear auth
      await _localDataSource.clearAuthData();
      return false;
    }
  }

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> updates) async {
    try {
      final updatedUser = await _remoteDataSource.updateUserProfile(updates);
      await _localDataSource.saveUserProfile(updatedUser);
      return updatedUser;
    } catch (e) {
      // Fallback to local update
      final currentUser = await _localDataSource.getUserProfile();
      if (currentUser != null) {
        final updatedUser = UserProfile.fromJson({
          ...currentUser.toJson(),
          ...updates,
          'updated_at': DateTime.now().toIso8601String(),
        });
        await _localDataSource.saveUserProfile(updatedUser);
        return updatedUser;
      }
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> clearAuth() async {
    await _localDataSource.clearAuthData();
    _remoteDataSource.clearAuthToken();
  }
}
