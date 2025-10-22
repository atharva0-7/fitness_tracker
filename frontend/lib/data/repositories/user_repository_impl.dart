import '../../domain/repositories/user_repository.dart';
import '../../core/models/user_profile.dart';
import '../data_sources/remote_data_source.dart';
import '../data_sources/local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  UserRepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required LocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<UserProfile> getUserProfile() async {
    try {
      // Try to get from remote first
      final remoteUser = await _remoteDataSource.getUserProfile();
      await _localDataSource.saveUserProfile(remoteUser);
      return remoteUser;
    } catch (e) {
      // Fallback to local storage
      final localUser = await _localDataSource.getUserProfile();
      if (localUser != null) {
        return localUser;
      }
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<UserProfile> updateUserProfile(Map<String, dynamic> updates) async {
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
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserGoals(
    Map<String, dynamic> goals,
  ) async {
    try {
      return await _remoteDataSource.updateUserGoals(goals);
    } catch (e) {
      throw Exception('Failed to update user goals: $e');
    }
  }
}
