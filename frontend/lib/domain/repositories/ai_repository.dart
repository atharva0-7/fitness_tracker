abstract class AiRepository {
  Future<String> chatWithAI(String message);
  Future<String> getWorkoutRecommendation(Map<String, dynamic> params);
  Future<String> getMealPlanRecommendation(Map<String, dynamic> params);
  Future<String> getNutritionAnalysis(Map<String, dynamic> data);
  Future<bool> checkHealth();
}
