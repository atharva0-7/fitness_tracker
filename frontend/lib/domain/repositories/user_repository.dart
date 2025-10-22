import '../../core/models/user_profile.dart';

abstract class UserRepository {
  Future<UserProfile> getUserProfile();
  Future<UserProfile> updateUserProfile(Map<String, dynamic> updates);
  Future<Map<String, dynamic>> updateUserGoals(Map<String, dynamic> goals);
}
