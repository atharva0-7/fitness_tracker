import 'package:equatable/equatable.dart';

class ProgressEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final double? weight;
  final double? bodyFat;
  final double? muscleMass;
  final double? waterPercentage;
  final double? boneDensity;
  final int? caloriesBurned;
  final int? steps;
  final double? distance; // in kilometers
  final int? activeMinutes;
  final int? heartRate;
  final String? notes;
  final List<String>? images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProgressEntity({
    required this.id,
    required this.userId,
    required this.date,
    this.weight,
    this.bodyFat,
    this.muscleMass,
    this.waterPercentage,
    this.boneDensity,
    this.caloriesBurned,
    this.steps,
    this.distance,
    this.activeMinutes,
    this.heartRate,
    this.notes,
    this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    date,
    weight,
    bodyFat,
    muscleMass,
    waterPercentage,
    boneDensity,
    caloriesBurned,
    steps,
    distance,
    activeMinutes,
    heartRate,
    notes,
    images,
    createdAt,
    updatedAt,
  ];
}

class WeightProgressEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final double weight;
  final double? bodyFat;
  final double? muscleMass;
  final String? notes;
  final DateTime createdAt;

  const WeightProgressEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.weight,
    this.bodyFat,
    this.muscleMass,
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    date,
    weight,
    bodyFat,
    muscleMass,
    notes,
    createdAt,
  ];
}

class BmiProgressEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final double weight;
  final double height;
  final double bmi;
  final String category;
  final DateTime createdAt;

  const BmiProgressEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.category,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    date,
    weight,
    height,
    bmi,
    category,
    createdAt,
  ];

  static String getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }
}

class CalorieProgressEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final int caloriesConsumed;
  final int caloriesBurned;
  final int targetCalories;
  final int netCalories;
  final DateTime createdAt;

  const CalorieProgressEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.caloriesConsumed,
    required this.caloriesBurned,
    required this.targetCalories,
    required this.netCalories,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    date,
    caloriesConsumed,
    caloriesBurned,
    targetCalories,
    netCalories,
    createdAt,
  ];

  double get caloriesProgress => caloriesConsumed / targetCalories;
  int get remainingCalories => targetCalories - caloriesConsumed;
}

class WorkoutProgressEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final int workoutsCompleted;
  final int totalWorkouts;
  final int totalDuration; // in minutes
  final int totalCaloriesBurned;
  final List<String> workoutTypes;
  final DateTime createdAt;

  const WorkoutProgressEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.workoutsCompleted,
    required this.totalWorkouts,
    required this.totalDuration,
    required this.totalCaloriesBurned,
    required this.workoutTypes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    date,
    workoutsCompleted,
    totalWorkouts,
    totalDuration,
    totalCaloriesBurned,
    workoutTypes,
    createdAt,
  ];

  double get completionRate => workoutsCompleted / totalWorkouts;
}

class ProgressSummaryEntity extends Equatable {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final double weightChange;
  final double bmiChange;
  final int totalCaloriesBurned;
  final int totalWorkoutsCompleted;
  final int totalSteps;
  final double totalDistance;
  final int totalActiveMinutes;
  final List<WeightProgressEntity> weightHistory;
  final List<BmiProgressEntity> bmiHistory;
  final List<CalorieProgressEntity> calorieHistory;
  final List<WorkoutProgressEntity> workoutHistory;

  const ProgressSummaryEntity({
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.weightChange,
    required this.bmiChange,
    required this.totalCaloriesBurned,
    required this.totalWorkoutsCompleted,
    required this.totalSteps,
    required this.totalDistance,
    required this.totalActiveMinutes,
    required this.weightHistory,
    required this.bmiHistory,
    required this.calorieHistory,
    required this.workoutHistory,
  });

  @override
  List<Object?> get props => [
    userId,
    startDate,
    endDate,
    weightChange,
    bmiChange,
    totalCaloriesBurned,
    totalWorkoutsCompleted,
    totalSteps,
    totalDistance,
    totalActiveMinutes,
    weightHistory,
    bmiHistory,
    calorieHistory,
    workoutHistory,
  ];
}

class GoalEntity extends Equatable {
  final String id;
  final String userId;
  final String type; // weight, bmi, calories, workouts, etc.
  final String title;
  final String description;
  final double targetValue;
  final double currentValue;
  final String unit;
  final DateTime targetDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCompleted;
  final bool isActive;

  const GoalEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.targetDate,
    required this.createdAt,
    required this.updatedAt,
    this.isCompleted = false,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    title,
    description,
    targetValue,
    currentValue,
    unit,
    targetDate,
    createdAt,
    updatedAt,
    isCompleted,
    isActive,
  ];

  double get progress => currentValue / targetValue;
  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;
  bool get isOverdue => DateTime.now().isAfter(targetDate) && !isCompleted;
}
