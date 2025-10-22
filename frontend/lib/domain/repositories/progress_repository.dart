abstract class ProgressRepository {
  Future<List<Map<String, dynamic>>> getProgressData();
  Future<Map<String, dynamic>> logProgress(Map<String, dynamic> progress);
  Future<Map<String, dynamic>> getProgressSummary();
  Future<List<Map<String, dynamic>>> getWeightProgress();
  Future<Map<String, dynamic>> logWeight(double weight);
}
