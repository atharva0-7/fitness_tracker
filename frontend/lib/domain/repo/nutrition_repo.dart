import 'package:dartz/dartz.dart';
import '../entity/meal_entity.dart';

abstract class NutritionRepo {
  // Daily Nutrition Tracking
  Future<Either<String, DailyNutritionEntity>> getDailyNutrition({
    required String userId,
    required DateTime date,
  });

  Future<Either<String, List<DailyNutritionEntity>>> getNutritionHistory({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  // Macro Tracking
  Future<Either<String, Map<String, double>>> getMacroBreakdown({
    required String userId,
    required DateTime date,
  });

  Future<Either<String, Map<String, double>>> getMacroProgress({
    required String userId,
    required DateTime date,
  });

  // Calorie Tracking
  Future<Either<String, int>> getCaloriesConsumed({
    required String userId,
    required DateTime date,
  });

  Future<Either<String, int>> getCaloriesBurned({
    required String userId,
    required DateTime date,
  });

  Future<Either<String, int>> getNetCalories({
    required String userId,
    required DateTime date,
  });

  // Water Intake
  Future<Either<String, double>> getWaterIntake({
    required String userId,
    required DateTime date,
  });

  Future<Either<String, void>> logWaterIntake({
    required String userId,
    required double amount, // in liters
    required DateTime date,
  });

  Future<Either<String, double>> getWaterGoal(String userId);

  Future<Either<String, void>> setWaterGoal({
    required String userId,
    required double goal, // in liters
  });

  // Nutrition Goals
  Future<Either<String, Map<String, int>>> getNutritionGoals(String userId);

  Future<Either<String, void>> setNutritionGoals({
    required String userId,
    required int targetCalories,
    required int targetProtein,
    required int targetCarbs,
    required int targetFat,
  });

  // Nutrition Analysis
  Future<Either<String, Map<String, dynamic>>> getNutritionAnalysis({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<String, List<String>>> getNutritionRecommendations({
    required String userId,
    required DateTime date,
  });

  // Food Database
  Future<Either<String, List<Map<String, dynamic>>>> searchFood({
    required String query,
    int limit = 20,
  });

  Future<Either<String, Map<String, dynamic>>> getFoodDetails(String foodId);

  // Barcode Scanning
  Future<Either<String, Map<String, dynamic>>> scanBarcode(String barcode);

  // Custom Foods
  Future<Either<String, Map<String, dynamic>>> createCustomFood({
    required String userId,
    required String name,
    required Map<String, dynamic> nutritionFacts,
  });

  Future<Either<String, List<Map<String, dynamic>>>> getUserCustomFoods(
    String userId,
  );

  // Nutrition Reports
  Future<Either<String, Map<String, dynamic>>> generateNutritionReport({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  // Meal Timing
  Future<Either<String, List<Map<String, dynamic>>>> getMealTiming({
    required String userId,
    required DateTime date,
  });

  Future<Either<String, void>> updateMealTiming({
    required String userId,
    required String mealType,
    required String time,
  });
}
