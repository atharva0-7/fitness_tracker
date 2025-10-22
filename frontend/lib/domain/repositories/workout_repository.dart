abstract class WorkoutRepository {
  Future<List<Map<String, dynamic>>> getWorkouts();
  Future<Map<String, dynamic>> getWorkout(String id);
  Future<Map<String, dynamic>> createWorkout(Map<String, dynamic> workout);
  Future<Map<String, dynamic>> updateWorkout(
    String id,
    Map<String, dynamic> updates,
  );
  Future<void> deleteWorkout(String id);
  Future<Map<String, dynamic>> logWorkoutSession(Map<String, dynamic> session);
  Future<List<Map<String, dynamic>>> getWorkoutHistory();
}
