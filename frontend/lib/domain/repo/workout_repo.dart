import 'package:dartz/dartz.dart';
import '../entity/workout_entity.dart';

abstract class WorkoutRepo {
  // Workout CRUD
  Future<Either<String, List<WorkoutEntity>>> getWorkouts({
    String? difficulty,
    String? type,
    String? bodyPart,
    int page = 1,
    int limit = 20,
  });

  Future<Either<String, WorkoutEntity>> getWorkoutById(String id);

  Future<Either<String, WorkoutEntity>> createWorkout(WorkoutEntity workout);

  Future<Either<String, WorkoutEntity>> updateWorkout(WorkoutEntity workout);

  Future<Either<String, void>> deleteWorkout(String id);

  // AI Generated Workouts
  Future<Either<String, WorkoutPlanEntity>> generateWorkoutPlan({
    required String userId,
    required String fitnessGoal,
    required String difficulty,
    required List<String> preferredTypes,
    required List<String> availableEquipment,
    required int duration, // in minutes per session
    required int daysPerWeek,
  });

  Future<Either<String, WorkoutEntity>> generateCustomWorkout({
    required String userId,
    required String type,
    required String difficulty,
    required List<String> bodyParts,
    required int duration,
    required List<String> availableEquipment,
  });

  // Workout Sessions
  Future<Either<String, WorkoutSessionEntity>> startWorkoutSession({
    required String userId,
    required String workoutId,
  });

  Future<Either<String, WorkoutSessionEntity>> updateWorkoutSession(
    WorkoutSessionEntity session,
  );

  Future<Either<String, WorkoutSessionEntity>> completeWorkoutSession({
    required String sessionId,
    required List<WorkoutSetEntity> sets,
    String? notes,
  });

  Future<Either<String, List<WorkoutSessionEntity>>> getWorkoutHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  });

  // Workout Plans
  Future<Either<String, List<WorkoutPlanEntity>>> getUserWorkoutPlans(
    String userId,
  );

  Future<Either<String, WorkoutPlanEntity>> getWorkoutPlanById(String id);

  Future<Either<String, WorkoutPlanEntity>> createWorkoutPlan(
    WorkoutPlanEntity plan,
  );

  Future<Either<String, WorkoutPlanEntity>> updateWorkoutPlan(
    WorkoutPlanEntity plan,
  );

  Future<Either<String, void>> deleteWorkoutPlan(String id);

  Future<Either<String, void>> activateWorkoutPlan(String id);

  // Favorites
  Future<Either<String, void>> addToFavorites({
    required String userId,
    required String workoutId,
  });

  Future<Either<String, void>> removeFromFavorites({
    required String userId,
    required String workoutId,
  });

  Future<Either<String, List<WorkoutEntity>>> getFavoriteWorkouts(
    String userId,
  );

  // Search and Filter
  Future<Either<String, List<WorkoutEntity>>> searchWorkouts({
    required String query,
    String? difficulty,
    String? type,
    String? bodyPart,
  });

  Future<Either<String, List<WorkoutEntity>>> getRecommendedWorkouts({
    required String userId,
    int limit = 10,
  });
}
