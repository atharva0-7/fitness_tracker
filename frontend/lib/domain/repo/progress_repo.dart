import 'package:dartz/dartz.dart';
import '../entity/progress_entity.dart';

abstract class ProgressRepo {
  // Progress Logging
  Future<Either<String, ProgressEntity>> logProgress({
    required String userId,
    required DateTime date,
    double? weight,
    double? bodyFat,
    double? muscleMass,
    double? waterPercentage,
    double? boneDensity,
    int? caloriesBurned,
    int? steps,
    double? distance,
    int? activeMinutes,
    int? heartRate,
    String? notes,
    List<String>? images,
  });

  Future<Either<String, ProgressEntity>> updateProgress({
    required String progressId,
    double? weight,
    double? bodyFat,
    double? muscleMass,
    double? waterPercentage,
    double? boneDensity,
    int? caloriesBurned,
    int? steps,
    double? distance,
    int? activeMinutes,
    int? heartRate,
    String? notes,
    List<String>? images,
  });

  Future<Either<String, void>> deleteProgress(String progressId);

  // Weight Tracking
  Future<Either<String, List<WeightProgressEntity>>> getWeightHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<String, WeightProgressEntity>> logWeight({
    required String userId,
    required double weight,
    double? bodyFat,
    double? muscleMass,
    String? notes,
  });

  Future<Either<String, double>> getCurrentWeight(String userId);

  Future<Either<String, double>> getWeightChange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  // BMI Tracking
  Future<Either<String, List<BmiProgressEntity>>> getBmiHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<String, BmiProgressEntity>> calculateBmi({
    required String userId,
    required double weight,
    required double height,
  });

  Future<Either<String, double>> getCurrentBmi(String userId);

  // Calorie Tracking
  Future<Either<String, List<CalorieProgressEntity>>> getCalorieHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<String, CalorieProgressEntity>> getDailyCalories({
    required String userId,
    required DateTime date,
  });

  // Workout Progress
  Future<Either<String, List<WorkoutProgressEntity>>> getWorkoutHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<String, WorkoutProgressEntity>> getDailyWorkoutProgress({
    required String userId,
    required DateTime date,
  });

  // Goals Management
  Future<Either<String, List<GoalEntity>>> getUserGoals(String userId);

  Future<Either<String, GoalEntity>> createGoal(GoalEntity goal);

  Future<Either<String, GoalEntity>> updateGoal(GoalEntity goal);

  Future<Either<String, void>> deleteGoal(String goalId);

  Future<Either<String, void>> completeGoal(String goalId);

  // Progress Summary
  Future<Either<String, ProgressSummaryEntity>> getProgressSummary({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<String, Map<String, dynamic>>> getProgressStats({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  // Charts Data
  Future<Either<String, List<Map<String, dynamic>>>> getWeightChartData({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<String, List<Map<String, dynamic>>>> getBmiChartData({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<String, List<Map<String, dynamic>>>> getCalorieChartData({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<String, List<Map<String, dynamic>>>> getWorkoutChartData({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  // Achievements
  Future<Either<String, List<Map<String, dynamic>>>> getUserAchievements(
    String userId,
  );

  Future<Either<String, Map<String, dynamic>>> getAchievementProgress({
    required String userId,
    required String achievementId,
  });

  // Progress Photos
  Future<Either<String, List<String>>> getProgressPhotos({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<String, void>> uploadProgressPhoto({
    required String userId,
    required String imagePath,
    required DateTime date,
  });

  Future<Either<String, void>> deleteProgressPhoto(String photoId);
}
