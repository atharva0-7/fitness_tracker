import 'package:dartz/dartz.dart';

abstract class AiRepo {
  // Chat with AI Assistant
  Future<Either<String, String>> chatWithAI({
    required String userId,
    required String message,
    String? context,
  });

  // Voice Input Processing
  Future<Either<String, String>> processVoiceInput({
    required String userId,
    required String audioPath,
  });

  Future<Either<String, String>> convertTextToSpeech({
    required String text,
    String? language,
  });

  // Workout Recommendations
  Future<Either<String, Map<String, dynamic>>> getWorkoutRecommendations({
    required String userId,
    required String fitnessGoal,
    required String difficulty,
    required List<String> preferences,
    required int duration,
  });

  Future<Either<String, Map<String, dynamic>>> getPersonalizedWorkout({
    required String userId,
    required String type,
    required String difficulty,
    required List<String> bodyParts,
    required int duration,
  });

  // Meal Recommendations
  Future<Either<String, Map<String, dynamic>>> getMealRecommendations({
    required String userId,
    required String mealType,
    required int targetCalories,
    required String dietaryPreference,
    required List<String> allergies,
  });

  Future<Either<String, Map<String, dynamic>>> getPersonalizedMealPlan({
    required String userId,
    required int targetCalories,
    required String dietaryPreference,
    required List<String> allergies,
    required int days,
  });

  // Nutrition Analysis
  Future<Either<String, Map<String, dynamic>>> analyzeNutrition({
    required String userId,
    required DateTime date,
  });

  Future<Either<String, List<String>>> getNutritionAdvice({
    required String userId,
    required Map<String, dynamic> nutritionData,
  });

  // Progress Analysis
  Future<Either<String, Map<String, dynamic>>> analyzeProgress({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<String, List<String>>> getProgressInsights({
    required String userId,
    required Map<String, dynamic> progressData,
  });

  // Goal Setting
  Future<Either<String, Map<String, dynamic>>> suggestGoals({
    required String userId,
    required String fitnessGoal,
    required Map<String, dynamic> currentStats,
  });

  Future<Either<String, Map<String, dynamic>>> adjustGoals({
    required String userId,
    required Map<String, dynamic> currentProgress,
  });

  // Health Insights
  Future<Either<String, Map<String, dynamic>>> getHealthInsights({
    required String userId,
    required Map<String, dynamic> healthData,
  });

  Future<Either<String, List<String>>> getHealthRecommendations({
    required String userId,
    required Map<String, dynamic> healthData,
  });

  // Motivation and Tips
  Future<Either<String, String>> getMotivationalMessage({
    required String userId,
    required String context,
  });

  Future<Either<String, List<String>>> getFitnessTips({
    required String userId,
    required String category,
  });

  // Image Analysis
  Future<Either<String, Map<String, dynamic>>> analyzeFoodImage({
    required String userId,
    required String imagePath,
  });

  Future<Either<String, Map<String, dynamic>>> analyzeProgressPhoto({
    required String userId,
    required String imagePath,
  });

  // Form Analysis
  Future<Either<String, Map<String, dynamic>>> analyzeExerciseForm({
    required String userId,
    required String exerciseId,
    required String videoPath,
  });

  // Personalized Coaching
  Future<Either<String, Map<String, dynamic>>> getCoachingAdvice({
    required String userId,
    required String category,
    required Map<String, dynamic> context,
  });

  Future<Either<String, List<String>>> getDailyTips({
    required String userId,
    required DateTime date,
  });
}
