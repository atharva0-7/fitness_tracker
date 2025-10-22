class DailyStats {
  final String id;
  final String userId;
  final DateTime date;
  final double caloriesConsumed;
  final double caloriesBurned;
  final double caloriesGoal;
  final double proteinConsumed;
  final double carbsConsumed;
  final double fatConsumed;
  final double waterIntake; // in liters
  final int steps;
  final int stepsGoal;
  final double weight;
  final int workoutMinutes;
  final int sleepHours;
  final double mood; // 1-10 scale
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyStats({
    required this.id,
    required this.userId,
    required this.date,
    required this.caloriesConsumed,
    required this.caloriesBurned,
    required this.caloriesGoal,
    required this.proteinConsumed,
    required this.carbsConsumed,
    required this.fatConsumed,
    required this.waterIntake,
    required this.steps,
    required this.stepsGoal,
    required this.weight,
    required this.workoutMinutes,
    required this.sleepHours,
    required this.mood,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Getters for calculated values
  double get caloriesRemaining => caloriesGoal - caloriesConsumed;
  double get caloriesDeficit => caloriesBurned - caloriesConsumed;
  double get stepsProgress => steps / stepsGoal;
  double get waterProgress => waterIntake / 2.5; // Assuming 2.5L goal
  double get workoutProgress => workoutMinutes / 30; // Assuming 30min goal
  double get sleepProgress => sleepHours / 8; // Assuming 8h goal

  bool get isCalorieGoalMet => caloriesConsumed >= caloriesGoal;
  bool get isStepsGoalMet => steps >= stepsGoal;
  bool get isWaterGoalMet => waterIntake >= 2.5;
  bool get isWorkoutGoalMet => workoutMinutes >= 30;
  bool get isSleepGoalMet => sleepHours >= 8;

  // Factory constructors
  factory DailyStats.empty(String userId) {
    final now = DateTime.now();
    return DailyStats(
      id: '',
      userId: userId,
      date: now,
      caloriesConsumed: 0,
      caloriesBurned: 0,
      caloriesGoal: 2000,
      proteinConsumed: 0,
      carbsConsumed: 0,
      fatConsumed: 0,
      waterIntake: 0,
      steps: 0,
      stepsGoal: 10000,
      weight: 70,
      workoutMinutes: 0,
      sleepHours: 0,
      mood: 5,
      notes: '',
      createdAt: now,
      updatedAt: now,
    );
  }

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      date: DateTime.parse(json['date']),
      caloriesConsumed: (json['calories_consumed'] ?? 0).toDouble(),
      caloriesBurned: (json['calories_burned'] ?? 0).toDouble(),
      caloriesGoal: (json['calories_goal'] ?? 2000).toDouble(),
      proteinConsumed: (json['protein_consumed'] ?? 0).toDouble(),
      carbsConsumed: (json['carbs_consumed'] ?? 0).toDouble(),
      fatConsumed: (json['fat_consumed'] ?? 0).toDouble(),
      waterIntake: (json['water_intake'] ?? 0).toDouble(),
      steps: json['steps'] ?? 0,
      stepsGoal: json['steps_goal'] ?? 10000,
      weight: (json['weight'] ?? 70).toDouble(),
      workoutMinutes: json['workout_minutes'] ?? 0,
      sleepHours: json['sleep_hours'] ?? 0,
      mood: (json['mood'] ?? 5).toDouble(),
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'calories_consumed': caloriesConsumed,
      'calories_burned': caloriesBurned,
      'calories_goal': caloriesGoal,
      'protein_consumed': proteinConsumed,
      'carbs_consumed': carbsConsumed,
      'fat_consumed': fatConsumed,
      'water_intake': waterIntake,
      'steps': steps,
      'steps_goal': stepsGoal,
      'weight': weight,
      'workout_minutes': workoutMinutes,
      'sleep_hours': sleepHours,
      'mood': mood,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  DailyStats copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? caloriesConsumed,
    double? caloriesBurned,
    double? caloriesGoal,
    double? proteinConsumed,
    double? carbsConsumed,
    double? fatConsumed,
    double? waterIntake,
    int? steps,
    int? stepsGoal,
    double? weight,
    int? workoutMinutes,
    int? sleepHours,
    double? mood,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyStats(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      caloriesGoal: caloriesGoal ?? this.caloriesGoal,
      proteinConsumed: proteinConsumed ?? this.proteinConsumed,
      carbsConsumed: carbsConsumed ?? this.carbsConsumed,
      fatConsumed: fatConsumed ?? this.fatConsumed,
      waterIntake: waterIntake ?? this.waterIntake,
      steps: steps ?? this.steps,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      weight: weight ?? this.weight,
      workoutMinutes: workoutMinutes ?? this.workoutMinutes,
      sleepHours: sleepHours ?? this.sleepHours,
      mood: mood ?? this.mood,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
