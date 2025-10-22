import '../../domain/repositories/ai_repository.dart';
import '../data_sources/remote_data_source.dart';

class AiRepositoryImpl implements AiRepository {
  final RemoteDataSource _remoteDataSource;

  AiRepositoryImpl({required RemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<String> chatWithAI(String message) async {
    try {
      return await _remoteDataSource.chatWithAI(message);
    } catch (e) {
      throw Exception('Failed to chat with AI: $e');
    }
  }

  @override
  Future<String> getWorkoutRecommendation(Map<String, dynamic> params) async {
    try {
      return await _remoteDataSource.getWorkoutRecommendation(params);
    } catch (e) {
      throw Exception('Failed to get workout recommendation: $e');
    }
  }

  @override
  Future<String> getMealPlanRecommendation(Map<String, dynamic> params) async {
    try {
      return await _remoteDataSource.getMealPlanRecommendation(params);
    } catch (e) {
      throw Exception('Failed to get meal plan recommendation: $e');
    }
  }

  @override
  Future<String> getNutritionAnalysis(Map<String, dynamic> data) async {
    try {
      return await _remoteDataSource.getNutritionAnalysis(data);
    } catch (e) {
      throw Exception('Failed to get nutrition analysis: $e');
    }
  }

  @override
  Future<bool> checkHealth() async {
    try {
      return await _remoteDataSource.checkHealth();
    } catch (e) {
      return false;
    }
  }
}
