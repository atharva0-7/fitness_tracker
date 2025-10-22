import '../../domain/repositories/workout_repository.dart';
import '../data_sources/remote_data_source.dart';
import '../data_sources/local_data_source.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  WorkoutRepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required LocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<List<Map<String, dynamic>>> getWorkouts() async {
    try {
      final workouts = await _remoteDataSource.getWorkouts();
      return workouts;
    } catch (e) {
      throw Exception('Failed to get workouts: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getWorkout(String id) async {
    try {
      return await _remoteDataSource.getWorkout(id);
    } catch (e) {
      throw Exception('Failed to get workout: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> createWorkout(
    Map<String, dynamic> workout,
  ) async {
    try {
      final createdWorkout = await _remoteDataSource.createWorkout(workout);
      return createdWorkout;
    } catch (e) {
      throw Exception('Failed to create workout: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateWorkout(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      return await _remoteDataSource.updateWorkout(id, updates);
    } catch (e) {
      throw Exception('Failed to update workout: $e');
    }
  }

  @override
  Future<void> deleteWorkout(String id) async {
    try {
      await _remoteDataSource.deleteWorkout(id);
    } catch (e) {
      throw Exception('Failed to delete workout: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> logWorkoutSession(
    Map<String, dynamic> session,
  ) async {
    try {
      final loggedSession = await _remoteDataSource.logWorkoutSession(session);

      // Also save to local storage for offline access
      await _localDataSource.addWorkoutToHistory(loggedSession);

      return loggedSession;
    } catch (e) {
      // Fallback to local storage
      await _localDataSource.addWorkoutToHistory(session);
      return session;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getWorkoutHistory() async {
    try {
      // Try to get from remote first
      final remoteHistory = await _remoteDataSource.getWorkoutHistory();
      await _localDataSource.saveWorkoutHistory(remoteHistory);
      return remoteHistory;
    } catch (e) {
      // Fallback to local storage
      return await _localDataSource.getWorkoutHistory();
    }
  }
}
