import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/models/user_profile.dart';
import '../../core/models/daily_stats.dart';
import '../../core/constants/network_constants.dart';

class RemoteDataSource {
  String? _authToken;

  // Headers
  Map<String, String> get _headers => {
    ...NetworkConstants.defaultHeaders,
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  // ==================== AUTHENTICATION APIs ====================

  /// Register a new user
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
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.registerEndpoint}',
        ),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
          'age': age,
          'gender': gender,
          'height': height,
          'weight': weight,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        // Store the auth token
        if (data['data']?['access_token'] != null) {
          setAuthToken(data['data']['access_token']);
        }
        return data;
      } else {
        throw Exception(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.loginEndpoint}',
        ),
        headers: _headers,
        body: json.encode({'email': email, 'password': password}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // Store the auth token
        if (data['data']?['access_token'] != null) {
          setAuthToken(data['data']['access_token']);
        }
        return data;
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.logoutEndpoint}',
        ),
        headers: _headers,
      );
    } catch (e) {
      // Ignore logout errors
    } finally {
      clearAuthToken();
    }
  }

  // ==================== USER PROFILE APIs ====================

  /// Get user profile
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.userProfileEndpoint}',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserProfile.fromJson(data['data']);
      } else {
        throw Exception('Failed to get user profile');
      }
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Update user profile
  Future<UserProfile> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.userProfileEndpoint}',
        ),
        headers: _headers,
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserProfile.fromJson(data['data']);
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Update user goals
  Future<Map<String, dynamic>> updateUserGoals(
    Map<String, dynamic> goals,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.userGoalsEndpoint}',
        ),
        headers: _headers,
        body: json.encode(goals),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update user goals');
      }
    } catch (e) {
      throw Exception('Failed to update user goals: $e');
    }
  }

  // ==================== WORKOUT APIs ====================

  /// Get all workouts
  Future<List<Map<String, dynamic>>> getWorkouts() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.workoutsEndpoint}',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to get workouts');
      }
    } catch (e) {
      throw Exception('Failed to get workouts: $e');
    }
  }

  /// Get workout by ID
  Future<Map<String, dynamic>> getWorkout(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.workoutsEndpoint}/\$id',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to get workout');
      }
    } catch (e) {
      throw Exception('Failed to get workout: $e');
    }
  }

  /// Create workout
  Future<Map<String, dynamic>> createWorkout(
    Map<String, dynamic> workout,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.workoutsEndpoint}',
        ),
        headers: _headers,
        body: json.encode(workout),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to create workout');
      }
    } catch (e) {
      throw Exception('Failed to create workout: $e');
    }
  }

  /// Update workout
  Future<Map<String, dynamic>> updateWorkout(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.workoutsEndpoint}/\$id',
        ),
        headers: _headers,
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to update workout');
      }
    } catch (e) {
      throw Exception('Failed to update workout: $e');
    }
  }

  /// Delete workout
  Future<void> deleteWorkout(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.workoutsEndpoint}/\$id',
        ),
        headers: _headers,
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete workout');
      }
    } catch (e) {
      throw Exception('Failed to delete workout: $e');
    }
  }

  /// Log workout session
  Future<Map<String, dynamic>> logWorkoutSession(
    Map<String, dynamic> session,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.workoutSessionsEndpoint}',
        ),
        headers: _headers,
        body: json.encode(session),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to log workout session');
      }
    } catch (e) {
      throw Exception('Failed to log workout session: $e');
    }
  }

  /// Get workout history
  Future<List<Map<String, dynamic>>> getWorkoutHistory() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.workoutHistoryEndpoint}',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to get workout history');
      }
    } catch (e) {
      throw Exception('Failed to get workout history: $e');
    }
  }

  // ==================== MEAL APIs ====================

  /// Get all meals
  Future<List<Map<String, dynamic>>> getMeals() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.mealsEndpoint}',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to get meals');
      }
    } catch (e) {
      throw Exception('Failed to get meals: $e');
    }
  }

  /// Get meal by ID
  Future<Map<String, dynamic>> getMeal(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.mealsEndpoint}/\$id',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to get meal');
      }
    } catch (e) {
      throw Exception('Failed to get meal: $e');
    }
  }

  /// Create meal
  Future<Map<String, dynamic>> createMeal(Map<String, dynamic> meal) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.mealsEndpoint}',
        ),
        headers: _headers,
        body: json.encode(meal),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to create meal');
      }
    } catch (e) {
      throw Exception('Failed to create meal: $e');
    }
  }

  /// Update meal
  Future<Map<String, dynamic>> updateMeal(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.mealsEndpoint}/\$id',
        ),
        headers: _headers,
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to update meal');
      }
    } catch (e) {
      throw Exception('Failed to update meal: $e');
    }
  }

  /// Delete meal
  Future<void> deleteMeal(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.mealsEndpoint}/\$id',
        ),
        headers: _headers,
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete meal');
      }
    } catch (e) {
      throw Exception('Failed to delete meal: $e');
    }
  }

  /// Log meal consumption
  Future<Map<String, dynamic>> logMealConsumption(
    Map<String, dynamic> mealLog,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.mealLogEndpoint}',
        ),
        headers: _headers,
        body: json.encode(mealLog),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to log meal consumption');
      }
    } catch (e) {
      throw Exception('Failed to log meal consumption: $e');
    }
  }

  /// Get meal history
  Future<List<Map<String, dynamic>>> getMealHistory() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.mealHistoryEndpoint}',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to get meal history');
      }
    } catch (e) {
      throw Exception('Failed to get meal history: $e');
    }
  }

  // ==================== NUTRITION APIs ====================

  /// Get nutrition log
  Future<List<Map<String, dynamic>>> getNutritionLog() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.nutritionLogEndpoint}',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to get nutrition log');
      }
    } catch (e) {
      throw Exception('Failed to get nutrition log: $e');
    }
  }

  /// Log nutrition data
  Future<Map<String, dynamic>> logNutrition(
    Map<String, dynamic> nutrition,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.nutritionLogEndpoint}',
        ),
        headers: _headers,
        body: json.encode(nutrition),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to log nutrition data');
      }
    } catch (e) {
      throw Exception('Failed to log nutrition data: $e');
    }
  }

  /// Get nutrition summary
  Future<Map<String, dynamic>> getNutritionSummary() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.nutritionSummaryEndpoint}',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to get nutrition summary');
      }
    } catch (e) {
      throw Exception('Failed to get nutrition summary: $e');
    }
  }

  // ==================== PROGRESS APIs ====================

  /// Get progress data
  Future<List<Map<String, dynamic>>> getProgressData() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.progressEndpoint}',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to get progress data');
      }
    } catch (e) {
      throw Exception('Failed to get progress data: $e');
    }
  }

  /// Log progress data
  Future<Map<String, dynamic>> logProgress(
    Map<String, dynamic> progress,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.progressEndpoint}',
        ),
        headers: _headers,
        body: json.encode(progress),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to log progress data');
      }
    } catch (e) {
      throw Exception('Failed to log progress data: $e');
    }
  }

  /// Get progress summary
  Future<Map<String, dynamic>> getProgressSummary() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.progressSummaryEndpoint}',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to get progress summary');
      }
    } catch (e) {
      throw Exception('Failed to get progress summary: $e');
    }
  }

  /// Get weight progress
  Future<List<Map<String, dynamic>>> getWeightProgress() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.weightProgressEndpoint}',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to get weight progress');
      }
    } catch (e) {
      throw Exception('Failed to get weight progress: $e');
    }
  }

  /// Log weight
  Future<Map<String, dynamic>> logWeight(double weight) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.baseUrl}${NetworkConstants.weightProgressEndpoint}',
        ),
        headers: _headers,
        body: json.encode({'weight': weight}),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to log weight');
      }
    } catch (e) {
      throw Exception('Failed to log weight: $e');
    }
  }

  // ==================== AI APIs ====================

  /// Chat with AI
  Future<String> chatWithAI(String message) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.aiBaseUrl}${NetworkConstants.aiChatEndpoint}',
        ),
        headers: _headers,
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }

  /// Get workout recommendation
  Future<String> getWorkoutRecommendation(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.aiBaseUrl}${NetworkConstants.aiWorkoutPlanEndpoint}',
        ),
        headers: _headers,
        body: json.encode(params),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['workout_plan'];
      } else {
        throw Exception('Failed to get workout recommendation');
      }
    } catch (e) {
      throw Exception('Failed to get workout recommendation: $e');
    }
  }

  /// Get meal plan recommendation
  Future<String> getMealPlanRecommendation(Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.aiBaseUrl}${NetworkConstants.aiMealPlanEndpoint}',
        ),
        headers: _headers,
        body: json.encode(params),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['meal_plan'];
      } else {
        throw Exception('Failed to get meal plan recommendation');
      }
    } catch (e) {
      throw Exception('Failed to get meal plan recommendation: $e');
    }
  }

  /// Get nutrition analysis
  Future<String> getNutritionAnalysis(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.aiBaseUrl}${NetworkConstants.aiNutritionAnalysisEndpoint}',
        ),
        headers: _headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['analysis'];
      } else {
        throw Exception('Failed to get nutrition analysis');
      }
    } catch (e) {
      throw Exception('Failed to get nutrition analysis: $e');
    }
  }

  // ==================== HEALTH CHECK ====================

  /// Check API health
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.aiBaseUrl}${NetworkConstants.aiHealthEndpoint}',
        ),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
