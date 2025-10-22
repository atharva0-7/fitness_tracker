class NetworkConstants {
  // Base URLs
  static const String baseUrl = 'http://localhost:5001/api';
  static const String aiBaseUrl = 'http://localhost:5001/api/ai';

  // Authentication Endpoints
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';

  // User Endpoints
  static const String userProfileEndpoint = '/user/profile';
  static const String userGoalsEndpoint = '/user/goals';

  // Workout Endpoints
  static const String workoutsEndpoint = '/workouts';
  static const String workoutSessionsEndpoint = '/workouts/sessions';
  static const String workoutHistoryEndpoint = '/workouts/history';

  // Meal Endpoints
  static const String mealsEndpoint = '/meals';
  static const String mealLogEndpoint = '/meals/log';
  static const String mealHistoryEndpoint = '/meals/history';

  // Nutrition Endpoints
  static const String nutritionLogEndpoint = '/nutrition/log';
  static const String nutritionSummaryEndpoint = '/nutrition/summary';

  // Progress Endpoints
  static const String progressEndpoint = '/progress';
  static const String progressSummaryEndpoint = '/progress/summary';
  static const String weightProgressEndpoint = '/progress/weight';

  // AI Endpoints
  static const String aiChatEndpoint = '/ai/chat';
  static const String aiHealthEndpoint = '/ai/health';
  static const String aiWorkoutPlanEndpoint = '/ai/workout-plan';
  static const String aiMealPlanEndpoint = '/ai/meal-plan';
  static const String aiNutritionAnalysisEndpoint = '/ai/nutrition-analysis';

  // HTTP Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
}
