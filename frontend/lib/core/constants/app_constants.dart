class AppConstants {
  // App Info
  static const String appName = 'FitAI';
  static const String appVersion = '1.0.0';

  // API Constants
  static const String baseUrl = 'http://localhost:5000/api';
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String workoutsCollection = 'workouts';
  static const String mealsCollection = 'meals';
  static const String progressCollection = 'progress';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String workoutImagesPath = 'workout_images';
  static const String mealImagesPath = 'meal_images';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Workout Constants
  static const List<String> difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
  static const List<String> workoutTypes = [
    'Cardio',
    'Strength',
    'Yoga',
    'HIIT',
    'Pilates',
    'CrossFit',
  ];
  static const List<String> bodyParts = [
    'Chest',
    'Back',
    'Arms',
    'Legs',
    'Shoulders',
    'Core',
    'Full Body',
  ];

  // Nutrition Constants
  static const List<String> mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];
  static const List<String> dietaryPreferences = [
    'Vegetarian',
    'Vegan',
    'Keto',
    'Paleo',
    'Mediterranean',
    'Low-Carb',
    'High-Protein',
  ];

  // Goals
  static const List<String> fitnessGoals = [
    'Weight Loss',
    'Muscle Gain',
    'Endurance',
    'Strength',
    'Flexibility',
    'General Fitness',
  ];

  // Error Messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
  static const String validationError =
      'Please check your input and try again.';
}
