import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/usecases/ai_usecases.dart';
import '../di/service_locator.dart';
import '../constants/network_constants.dart';

class GeminiService {
  final Map<String, String> _headers = NetworkConstants.defaultHeaders;
  final AiUseCases _aiUseCases = sl<AiUseCases>();

  GeminiService() {
    // All AI calls go through Flask backend
  }

  Future<String> sendMessage(String message) async {
    try {
      print('🤖 Sending message to Flask backend: $message');

      // Try using the AI use case first
      try {
        final response = await _aiUseCases.chatWithAI(message);
        print('✅ Backend response received: ${response.substring(0, 100)}...');
        return response;
      } catch (e) {
        print('⚠️ AI use case failed, falling back to direct HTTP: $e');
      }

      // Fallback to direct HTTP call
      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.aiBaseUrl}${NetworkConstants.aiChatEndpoint}',
        ),
        headers: _headers,
        body: json.encode({
          'message': message,
          'context': 'fitness_nutrition_assistant',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(
          '✅ Backend response received: ${data['response']?.substring(0, 100)}...',
        );
        return data['response'] ??
            'AI service is temporarily unavailable. Please try again later.';
      } else {
        print('❌ Backend error: ${response.statusCode} - ${response.body}');
        throw Exception('AI service error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Network error: $e');
      throw Exception(
        'Failed to connect to AI service. Please check your internet connection and try again.',
      );
    }
  }

  Future<String> getWorkoutRecommendation({
    required String fitnessGoal,
    required String fitnessLevel,
    required String equipment,
    required int duration,
  }) async {
    try {
      print('🤖 Getting workout recommendation from backend...');

      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.aiBaseUrl}${NetworkConstants.aiWorkoutPlanEndpoint}',
        ),
        headers: _headers,
        body: json.encode({
          'fitness_goal': fitnessGoal,
          'difficulty': fitnessLevel,
          'available_equipment': [equipment],
          'workout_duration': duration,
          'days_per_week': 3,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['plan_name'] ??
            'AI service is temporarily unavailable. Please try again later.';
      } else {
        throw Exception('AI service error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Workout recommendation error: $e');
      throw Exception(
        'Failed to generate workout recommendation. Please try again later.',
      );
    }
  }

  Future<String> getMealPlanRecommendation({
    required String dietaryPreference,
    required int targetCalories,
    required List<String> allergies,
  }) async {
    try {
      print('🤖 Getting meal plan from backend...');

      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.aiBaseUrl}${NetworkConstants.aiMealPlanEndpoint}',
        ),
        headers: _headers,
        body: json.encode({
          'dietary_preference': dietaryPreference,
          'target_calories': targetCalories,
          'allergies': allergies,
          'days': 7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['plan_name'] ??
            'AI service is temporarily unavailable. Please try again later.';
      } else {
        throw Exception('AI service error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Meal plan error: $e');
      throw Exception('Failed to generate meal plan. Please try again later.');
    }
  }

  Future<String> analyzeProgress({
    required double currentWeight,
    required double targetWeight,
    required int daysActive,
    required double caloriesBurned,
  }) async {
    try {
      print('🤖 Analyzing progress with backend...');

      final response = await http.post(
        Uri.parse(
          '${NetworkConstants.aiBaseUrl}${NetworkConstants.aiNutritionAnalysisEndpoint}',
        ),
        headers: _headers,
        body: json.encode({
          'current_weight': currentWeight,
          'target_weight': targetWeight,
          'calories_consumed': caloriesBurned,
          'target_calories': 2000,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['overall_assessment'] ??
            'AI service is temporarily unavailable. Please try again later.';
      } else {
        throw Exception('AI service error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Progress analysis error: $e');
      throw Exception('Failed to analyze progress. Please try again later.');
    }
  }

  Future<bool> testConnection() async {
    try {
      print('🤖 Testing Flask backend connection...');

      final response = await http.get(
        Uri.parse(
          '${NetworkConstants.aiBaseUrl}${NetworkConstants.aiHealthEndpoint}',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        print('✅ Flask backend connection successful!');
        return true;
      } else {
        print('❌ Flask backend connection failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Flask backend connection failed: $e');
      return false;
    }
  }

  void resetChat() {
    // No need to reset chat session since we're using stateless API calls
    print('🔄 Chat reset - ready for new conversation');
  }
}
