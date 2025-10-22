abstract class MealRepository {
  Future<List<Map<String, dynamic>>> getMeals();
  Future<Map<String, dynamic>> getMeal(String id);
  Future<Map<String, dynamic>> createMeal(Map<String, dynamic> meal);
  Future<Map<String, dynamic>> updateMeal(
    String id,
    Map<String, dynamic> updates,
  );
  Future<void> deleteMeal(String id);
  Future<Map<String, dynamic>> logMealConsumption(Map<String, dynamic> mealLog);
  Future<List<Map<String, dynamic>>> getMealHistory();
}
