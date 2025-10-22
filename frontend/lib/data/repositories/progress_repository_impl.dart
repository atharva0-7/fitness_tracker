import '../../domain/repositories/progress_repository.dart';
import '../data_sources/remote_data_source.dart';
import '../data_sources/local_data_source.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  ProgressRepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required LocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<List<Map<String, dynamic>>> getProgressData() async {
    try {
      return await _remoteDataSource.getProgressData();
    } catch (e) {
      throw Exception('Failed to get progress data: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> logProgress(
    Map<String, dynamic> progress,
  ) async {
    try {
      return await _remoteDataSource.logProgress(progress);
    } catch (e) {
      throw Exception('Failed to log progress: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getProgressSummary() async {
    try {
      return await _remoteDataSource.getProgressSummary();
    } catch (e) {
      throw Exception('Failed to get progress summary: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getWeightProgress() async {
    try {
      return await _remoteDataSource.getWeightProgress();
    } catch (e) {
      throw Exception('Failed to get weight progress: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> logWeight(double weight) async {
    try {
      return await _remoteDataSource.logWeight(weight);
    } catch (e) {
      throw Exception('Failed to log weight: $e');
    }
  }
}
