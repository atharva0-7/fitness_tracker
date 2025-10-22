import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/daily_stats.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/ai_usecases.dart';
import '../../core/di/service_locator.dart';

class DataService {
  static const String _userProfileKey = 'user_profile';
  static const String _dailyStatsKey = 'daily_stats';
  static const String _workoutHistoryKey = 'workout_history';
  static const String _mealHistoryKey = 'meal_history';

  static final AuthUseCases _authUseCases = sl<AuthUseCases>();
  static final AiUseCases _aiUseCases = sl<AiUseCases>();

  // User Profile Management
  static Future<UserProfile> getUserProfile() async {
    try {
      // Try to get from use case first
      final profile = await _authUseCases.getCurrentUser();
      if (profile != null) {
        await saveUserProfile(profile);
        return profile;
      }
    } catch (e) {
      // Fallback to local storage
    }

    // Fallback to local storage
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_userProfileKey);

    if (profileJson != null) {
      return UserProfile.fromJson(json.decode(profileJson));
    }

    return UserProfile.empty();
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileKey, json.encode(profile.toJson()));
  }

  static Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      // Try to update via use case first
      final updatedProfile = await _authUseCases.updateProfile(updates);
      await saveUserProfile(updatedProfile);
      return;
    } catch (e) {
      // Fallback to local update
    }

    // Fallback to local update
    final currentProfile = await getUserProfile();
    final updatedProfile = UserProfile.fromJson({
      ...currentProfile.toJson(),
      ...updates,
      'updated_at': DateTime.now().toIso8601String(),
    });
    await saveUserProfile(updatedProfile);
  }

  // Daily Stats Management
  static Future<DailyStats> getTodayStats(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey =
        '${_dailyStatsKey}_${today.year}_${today.month}_${today.day}';
    final statsJson = prefs.getString(todayKey);

    if (statsJson != null) {
      return DailyStats.fromJson(json.decode(statsJson));
    }

    return DailyStats.empty(userId);
  }

  static Future<void> saveTodayStats(DailyStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final today = stats.date;
    final todayKey =
        '${_dailyStatsKey}_${today.year}_${today.month}_${today.day}';
    await prefs.setString(todayKey, json.encode(stats.toJson()));
  }

  static Future<void> updateTodayStats(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    final currentStats = await getTodayStats(userId);
    final updatedStats = DailyStats.fromJson({
      ...currentStats.toJson(),
      ...updates,
      'updated_at': DateTime.now().toIso8601String(),
    });
    await saveTodayStats(updatedStats);
  }

  static Future<List<DailyStats>> getWeeklyStats(String userId) async {
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
        weeklyStats.add(DailyStats.empty(userId).copyWith(date: date));
      }
    }

    return weeklyStats;
  }

  // Workout History Management
  static Future<List<Map<String, dynamic>>> getWorkoutHistory() async {
    try {
      // Try to get from use case first
      final isAuthenticated = await _authUseCases.isAuthenticated();
      if (isAuthenticated) {
        // This would need to be implemented through a workout use case
        // For now, fallback to local storage
      }
    } catch (e) {
      // Fallback to local storage
    }

    // Fallback to local storage
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_workoutHistoryKey);

    if (historyJson != null) {
      final List<dynamic> history = json.decode(historyJson);
      return history.cast<Map<String, dynamic>>();
    }

    return [];
  }

  static Future<void> _saveWorkoutHistory(
    List<Map<String, dynamic>> history,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_workoutHistoryKey, json.encode(history));
  }

  static Future<void> addWorkout(Map<String, dynamic> workout) async {
    try {
      // Try to add via use case first
      final isAuthenticated = await _authUseCases.isAuthenticated();
      if (isAuthenticated) {
        // This would need to be implemented through a workout use case
        // For now, fallback to local storage
      }
    } catch (e) {
      // Fallback to local storage
    }

    // Fallback to local storage
    final history = await getWorkoutHistory();
    workout['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    workout['completed_at'] = DateTime.now().toIso8601String();
    history.add(workout);

    await _saveWorkoutHistory(history);
  }

  static Future<void> updateWorkout(
    String workoutId,
    Map<String, dynamic> updates,
  ) async {
    final history = await getWorkoutHistory();
    final index = history.indexWhere((w) => w['id'] == workoutId);

    if (index != -1) {
      history[index] = {...history[index], ...updates};
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_workoutHistoryKey, json.encode(history));
    }
  }

  // Meal History Management
  static Future<List<Map<String, dynamic>>> getMealHistory() async {
    try {
      // Try to get from use case first
      final isAuthenticated = await _authUseCases.isAuthenticated();
      if (isAuthenticated) {
        // This would need to be implemented through a meal use case
        // For now, fallback to local storage
      }
    } catch (e) {
      // Fallback to local storage
    }

    // Fallback to local storage
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_mealHistoryKey);

    if (historyJson != null) {
      final List<dynamic> history = json.decode(historyJson);
      return history.cast<Map<String, dynamic>>();
    }

    return [];
  }

  static Future<void> _saveMealHistory(
    List<Map<String, dynamic>> history,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mealHistoryKey, json.encode(history));
  }

  static Future<void> addMeal(Map<String, dynamic> meal) async {
    try {
      // Try to add via use case first
      final isAuthenticated = await _authUseCases.isAuthenticated();
      if (isAuthenticated) {
        // This would need to be implemented through a meal use case
        // For now, fallback to local storage
      }
    } catch (e) {
      // Fallback to local storage
    }

    // Fallback to local storage
    final history = await getMealHistory();
    meal['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    meal['logged_at'] = DateTime.now().toIso8601String();
    history.add(meal);

    await _saveMealHistory(history);
  }

  static Future<void> updateMeal(
    String mealId,
    Map<String, dynamic> updates,
  ) async {
    final history = await getMealHistory();
    final index = history.indexWhere((m) => m['id'] == mealId);

    if (index != -1) {
      history[index] = {...history[index], ...updates};
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_mealHistoryKey, json.encode(history));
    }
  }

  // Progress Tracking
  static Future<Map<String, dynamic>> getProgressSummary(String userId) async {
    final weeklyStats = await getWeeklyStats(userId);
    final workoutHistory = await getWorkoutHistory();
    final mealHistory = await getMealHistory();

    // Calculate weekly averages
    final avgCalories =
        weeklyStats.map((s) => s.caloriesConsumed).reduce((a, b) => a + b) / 7;
    final avgSteps =
        weeklyStats.map((s) => s.steps).reduce((a, b) => a + b) / 7;
    final avgWorkoutMinutes =
        weeklyStats.map((s) => s.workoutMinutes).reduce((a, b) => a + b) / 7;
    final avgWeight =
        weeklyStats.map((s) => s.weight).reduce((a, b) => a + b) / 7;

    // Calculate trends
    final weightTrend =
        weeklyStats.length > 1
            ? weeklyStats.last.weight - weeklyStats.first.weight
            : 0.0;

    final caloriesTrend =
        weeklyStats.length > 1
            ? weeklyStats.last.caloriesConsumed -
                weeklyStats.first.caloriesConsumed
            : 0.0;

    // Count achievements
    final workoutsThisWeek =
        workoutHistory.where((w) {
          final workoutDate = DateTime.parse(w['completed_at']);
          final weekAgo = DateTime.now().subtract(const Duration(days: 7));
          return workoutDate.isAfter(weekAgo);
        }).length;

    final mealsThisWeek =
        mealHistory.where((m) {
          final mealDate = DateTime.parse(m['logged_at']);
          final weekAgo = DateTime.now().subtract(const Duration(days: 7));
          return mealDate.isAfter(weekAgo);
        }).length;

    return {
      'weekly_averages': {
        'calories': avgCalories,
        'steps': avgSteps,
        'workout_minutes': avgWorkoutMinutes,
        'weight': avgWeight,
      },
      'trends': {'weight': weightTrend, 'calories': caloriesTrend},
      'counts': {
        'workouts_this_week': workoutsThisWeek,
        'meals_this_week': mealsThisWeek,
      },
      'goals_met': {
        'calories': weeklyStats.where((s) => s.isCalorieGoalMet).length,
        'steps': weeklyStats.where((s) => s.isStepsGoalMet).length,
        'workouts': weeklyStats.where((s) => s.isWorkoutGoalMet).length,
      },
    };
  }

  // Data Export/Import
  static Future<Map<String, dynamic>> exportAllData(String userId) async {
    final profile = await getUserProfile();
    final weeklyStats = await getWeeklyStats(userId);
    final workoutHistory = await getWorkoutHistory();
    final mealHistory = await getMealHistory();

    return {
      'user_profile': profile.toJson(),
      'weekly_stats': weeklyStats.map((s) => s.toJson()).toList(),
      'workout_history': workoutHistory,
      'meal_history': mealHistory,
      'exported_at': DateTime.now().toIso8601String(),
    };
  }

  static Future<void> importData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    if (data['user_profile'] != null) {
      await prefs.setString(_userProfileKey, json.encode(data['user_profile']));
    }

    if (data['workout_history'] != null) {
      await prefs.setString(
        _workoutHistoryKey,
        json.encode(data['workout_history']),
      );
    }

    if (data['meal_history'] != null) {
      await prefs.setString(_mealHistoryKey, json.encode(data['meal_history']));
    }

    if (data['weekly_stats'] != null) {
      for (final statsData in data['weekly_stats']) {
        final stats = DailyStats.fromJson(statsData);
        final date = stats.date;
        final dateKey =
            '${_dailyStatsKey}_${date.year}_${date.month}_${date.day}';
        await prefs.setString(dateKey, json.encode(stats.toJson()));
      }
    }
  }

  // Clear all data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProfileKey);
    await prefs.remove(_dailyStatsKey);
    await prefs.remove(_workoutHistoryKey);
    await prefs.remove(_mealHistoryKey);
  }
}
