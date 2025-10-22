import '../repositories/ai_repository.dart';

class AiUseCases {
  final AiRepository _aiRepository;

  AiUseCases({required AiRepository aiRepository})
    : _aiRepository = aiRepository;

  Future<String> chatWithAI(String message) async {
    return await _aiRepository.chatWithAI(message);
  }

  Future<String> getWorkoutRecommendation({
    required String fitnessGoal,
    required String fitnessLevel,
    required String equipment,
  }) async {
    return await _aiRepository.getWorkoutRecommendation({
      'fitness_goal': fitnessGoal,
      'fitness_level': fitnessLevel,
      'equipment': equipment,
    });
  }

  Future<String> getMealPlanRecommendation({
    required String dietaryPreference,
    required int targetCalories,
    required List<String> allergies,
  }) async {
    return await _aiRepository.getMealPlanRecommendation({
      'dietary_preference': dietaryPreference,
      'target_calories': targetCalories,
      'allergies': allergies,
    });
  }

  Future<String> getNutritionAnalysis({
    required double currentWeight,
    required double targetWeight,
    required List<String> achievements,
  }) async {
    return await _aiRepository.getNutritionAnalysis({
      'current_weight': currentWeight,
      'target_weight': targetWeight,
      'achievements': achievements,
    });
  }

  Future<bool> checkHealth() async {
    return await _aiRepository.checkHealth();
  }
}
