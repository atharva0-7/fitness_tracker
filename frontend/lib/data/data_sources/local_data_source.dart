import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/user_profile.dart';
import '../../core/models/daily_stats.dart';

class LocalDataSource {
  static const String _userProfileKey = 'user_profile';
  static const String _dailyStatsKey = 'daily_stats';
  static const String _workoutHistoryKey = 'workout_history';
  static const String _mealHistoryKey = 'meal_history';
  static const String _authTokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // ==================== USER PROFILE MANAGEMENT ====================

  /// Get user profile from local storage
  Future<UserProfile?> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_userProfileKey);

      if (profileJson != null) {
        return UserProfile.fromJson(json.decode(profileJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Save user profile to local storage
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userProfileKey, json.encode(profile.toJson()));
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  /// Clear user profile from local storage
  Future<void> clearUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userProfileKey);
    } catch (e) {
      throw Exception('Failed to clear user profile: $e');
    }
  }

  // ==================== DAILY STATS MANAGEMENT ====================

  /// Get today's stats from local storage
  Future<DailyStats?> getTodayStats(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();
      final todayKey =
          '${_dailyStatsKey}_${today.year}_${today.month}_${today.day}';
      final statsJson = prefs.getString(todayKey);

      if (statsJson != null) {
        return DailyStats.fromJson(json.decode(statsJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Save today's stats to local storage
  Future<void> saveTodayStats(DailyStats stats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = stats.date;
      final todayKey =
          '${_dailyStatsKey}_${today.year}_${today.month}_${today.day}';
      await prefs.setString(todayKey, json.encode(stats.toJson()));
    } catch (e) {
      throw Exception('Failed to save today stats: $e');
    }
  }

  /// Get weekly stats from local storage
  Future<List<DailyStats>> getWeeklyStats(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();
      final List<DailyStats> weeklyStats = [];

      for (int i = 6; i >= 0; i--) {
        final date = today.subtract(Duration(days: i));
        final dateKey =
            '${_dailyStatsKey}_${date.year}_${date.month}_${date.day}';
        final statsJson = prefs.getString(dateKey);

        if (statsJson != null) {
          weeklyStats.add(DailyStats.fromJson(json.decode(statsJson)));
        } else {
          // Add an empty stats entry for days with no data
          weeklyStats.add(DailyStats.empty(userId).copyWith(date: date));
        }
      }

      return weeklyStats;
    } catch (e) {
      return [];
    }
  }

  /// Clear all daily stats
  Future<void> clearDailyStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_dailyStatsKey)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      throw Exception('Failed to clear daily stats: $e');
    }
  }

  // ==================== WORKOUT HISTORY MANAGEMENT ====================

  /// Get workout history from local storage
  Future<List<Map<String, dynamic>>> getWorkoutHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_workoutHistoryKey);

      if (historyJson != null) {
        final List<dynamic> history = json.decode(historyJson);
        return history.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Save workout history to local storage
  Future<void> saveWorkoutHistory(List<Map<String, dynamic>> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_workoutHistoryKey, json.encode(history));
    } catch (e) {
      throw Exception('Failed to save workout history: $e');
    }
  }

  /// Add workout to history
  Future<void> addWorkoutToHistory(Map<String, dynamic> workout) async {
    try {
      final history = await getWorkoutHistory();
      workout['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      workout['completed_at'] = DateTime.now().toIso8601String();
      history.add(workout);
      await saveWorkoutHistory(history);
    } catch (e) {
      throw Exception('Failed to add workout to history: $e');
    }
  }

  /// Update workout in history
  Future<void> updateWorkoutInHistory(
    String workoutId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final history = await getWorkoutHistory();
      final index = history.indexWhere((w) => w['id'] == workoutId);

      if (index != -1) {
        history[index] = {...history[index], ...updates};
        await saveWorkoutHistory(history);
      }
    } catch (e) {
      throw Exception('Failed to update workout in history: $e');
    }
  }

  /// Clear workout history
  Future<void> clearWorkoutHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_workoutHistoryKey);
    } catch (e) {
      throw Exception('Failed to clear workout history: $e');
    }
  }

  // ==================== MEAL HISTORY MANAGEMENT ====================

  /// Get meal history from local storage
  Future<List<Map<String, dynamic>>> getMealHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_mealHistoryKey);

      if (historyJson != null) {
        final List<dynamic> history = json.decode(historyJson);
        return history.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Save meal history to local storage
  Future<void> saveMealHistory(List<Map<String, dynamic>> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_mealHistoryKey, json.encode(history));
    } catch (e) {
      throw Exception('Failed to save meal history: $e');
    }
  }

  /// Add meal to history
  Future<void> addMealToHistory(Map<String, dynamic> meal) async {
    try {
      final history = await getMealHistory();
      meal['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      meal['logged_at'] = DateTime.now().toIso8601String();
      history.add(meal);
      await saveMealHistory(history);
    } catch (e) {
      throw Exception('Failed to add meal to history: $e');
    }
  }

  /// Update meal in history
  Future<void> updateMealInHistory(
    String mealId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final history = await getMealHistory();
      final index = history.indexWhere((m) => m['id'] == mealId);

      if (index != -1) {
        history[index] = {...history[index], ...updates};
        await saveMealHistory(history);
      }
    } catch (e) {
      throw Exception('Failed to update meal in history: $e');
    }
  }

  /// Clear meal history
  Future<void> clearMealHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_mealHistoryKey);
    } catch (e) {
      throw Exception('Failed to clear meal history: $e');
    }
  }

  // ==================== AUTHENTICATION MANAGEMENT ====================

  /// Get auth token from local storage
  Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_authTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Save auth token to local storage
  Future<void> saveAuthToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authTokenKey, token);
    } catch (e) {
      throw Exception('Failed to save auth token: $e');
    }
  }

  /// Get user data from local storage
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        return json.decode(userJson);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Save user data to local storage
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(userData));
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  /// Clear authentication data
  Future<void> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      throw Exception('Failed to clear auth data: $e');
    }
  }

  // ==================== GENERAL UTILITIES ====================

  /// Clear all data
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userProfileKey);
      await prefs.remove(_workoutHistoryKey);
      await prefs.remove(_mealHistoryKey);
      await clearDailyStats();
      await clearAuthData();
    } catch (e) {
      throw Exception('Failed to clear all data: $e');
    }
  }

  /// Export all data
  Future<Map<String, dynamic>> exportAllData() async {
    try {
      final profile = await getUserProfile();
      final workoutHistory = await getWorkoutHistory();
      final mealHistory = await getMealHistory();
      final authToken = await getAuthToken();
      final userData = await getUserData();

      return {
        'user_profile': profile?.toJson(),
        'workout_history': workoutHistory,
        'meal_history': mealHistory,
        'auth_token': authToken,
        'user_data': userData,
      };
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  /// Import data
  Future<void> importData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (data['user_profile'] != null) {
        await prefs.setString(
          _userProfileKey,
          json.encode(data['user_profile']),
        );
      }

      if (data['workout_history'] != null) {
        await prefs.setString(
          _workoutHistoryKey,
          json.encode(data['workout_history']),
        );
      }

      if (data['meal_history'] != null) {
        await prefs.setString(
          _mealHistoryKey,
          json.encode(data['meal_history']),
        );
      }

      if (data['auth_token'] != null) {
        await prefs.setString(_authTokenKey, data['auth_token']);
      }

      if (data['user_data'] != null) {
        await prefs.setString(_userKey, json.encode(data['user_data']));
      }
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }
}
