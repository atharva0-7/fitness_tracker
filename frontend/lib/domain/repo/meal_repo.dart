import 'package:dartz/dartz.dart';
import '../entity/meal_entity.dart';

abstract class MealRepo {
  // Meal CRUD
  Future<Either<String, List<MealEntity>>> getMeals({
    String? type,
    String? dietaryPreference,
    int page = 1,
    int limit = 20,
  });

  Future<Either<String, MealEntity>> getMealById(String id);

  Future<Either<String, MealEntity>> createMeal(MealEntity meal);

  Future<Either<String, MealEntity>> updateMeal(MealEntity meal);

  Future<Either<String, void>> deleteMeal(String id);

  // AI Generated Meal Plans
  Future<Either<String, MealPlanEntity>> generateMealPlan({
    required String userId,
    required int targetCalories,
    required String dietaryPreference,
    required List<String> allergies,
    required int days,
    required List<String> mealTypes,
  });

  Future<Either<String, MealEntity>> generateCustomMeal({
    required String userId,
    required String type,
    required int targetCalories,
    required String dietaryPreference,
    required List<String> ingredients,
    required List<String> allergies,
  });

  // Meal Plans
  Future<Either<String, List<MealPlanEntity>>> getUserMealPlans(String userId);

  Future<Either<String, MealPlanEntity>> getMealPlanById(String id);

  Future<Either<String, MealPlanEntity>> createMealPlan(MealPlanEntity plan);

  Future<Either<String, MealPlanEntity>> updateMealPlan(MealPlanEntity plan);

  Future<Either<String, void>> deleteMealPlan(String id);

  Future<Either<String, void>> activateMealPlan(String id);

  // Nutrition Logging
  Future<Either<String, NutritionLogEntity>> logMeal({
    required String userId,
    required String mealId,
    required double quantity,
    required String unit,
    String? notes,
  });

  Future<Either<String, List<NutritionLogEntity>>> getNutritionLogs({
    required String userId,
    DateTime? date,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<String, DailyNutritionEntity>> getDailyNutrition({
    required String userId,
    required DateTime date,
  });

  Future<Either<String, void>> updateNutritionLog(NutritionLogEntity log);

  Future<Either<String, void>> deleteNutritionLog(String logId);

  // Favorites
  Future<Either<String, void>> addToFavorites({
    required String userId,
    required String mealId,
  });

  Future<Either<String, void>> removeFromFavorites({
    required String userId,
    required String mealId,
  });

  Future<Either<String, List<MealEntity>>> getFavoriteMeals(String userId);

  // Search and Filter
  Future<Either<String, List<MealEntity>>> searchMeals({
    required String query,
    String? type,
    String? dietaryPreference,
    int? maxCalories,
    int? maxPrepTime,
  });

  Future<Either<String, List<MealEntity>>> getRecommendedMeals({
    required String userId,
    required String type,
    int limit = 10,
  });

  // Meal Suggestions
  Future<Either<String, List<MealEntity>>> getMealSuggestions({
    required String userId,
    required String type,
    required int targetCalories,
    required String dietaryPreference,
  });
}
