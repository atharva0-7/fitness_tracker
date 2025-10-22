import '../../domain/repositories/meal_repository.dart';
import '../data_sources/remote_data_source.dart';
import '../data_sources/local_data_source.dart';

class MealRepositoryImpl implements MealRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  MealRepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required LocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<List<Map<String, dynamic>>> getMeals() async {
    try {
      final meals = await _remoteDataSource.getMeals();
      return meals;
    } catch (e) {
      throw Exception('Failed to get meals: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMeal(String id) async {
    try {
      return await _remoteDataSource.getMeal(id);
    } catch (e) {
      throw Exception('Failed to get meal: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> createMeal(Map<String, dynamic> meal) async {
    try {
      final createdMeal = await _remoteDataSource.createMeal(meal);
      return createdMeal;
    } catch (e) {
      throw Exception('Failed to create meal: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateMeal(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      return await _remoteDataSource.updateMeal(id, updates);
    } catch (e) {
      throw Exception('Failed to update meal: $e');
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    try {
      await _remoteDataSource.deleteMeal(id);
    } catch (e) {
      throw Exception('Failed to delete meal: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> logMealConsumption(
    Map<String, dynamic> mealLog,
  ) async {
    try {
      final loggedMeal = await _remoteDataSource.logMealConsumption(mealLog);

      // Also save to local storage for offline access
      await _localDataSource.addMealToHistory(loggedMeal);

      return loggedMeal;
    } catch (e) {
      // Fallback to local storage
      await _localDataSource.addMealToHistory(mealLog);
      return mealLog;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMealHistory() async {
    try {
      // Try to get from remote first
      final remoteHistory = await _remoteDataSource.getMealHistory();
      await _localDataSource.saveMealHistory(remoteHistory);
      return remoteHistory;
    } catch (e) {
      // Fallback to local storage
      return await _localDataSource.getMealHistory();
    }
  }
}
