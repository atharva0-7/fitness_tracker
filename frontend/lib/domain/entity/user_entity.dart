import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserGoalsEntity? goals;
  final UserPreferencesEntity? preferences;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.goals,
    this.preferences,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    profileImageUrl,
    createdAt,
    updatedAt,
    goals,
    preferences,
  ];

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserGoalsEntity? goals,
    UserPreferencesEntity? preferences,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      goals: goals ?? this.goals,
      preferences: preferences ?? this.preferences,
    );
  }
}

class UserGoalsEntity extends Equatable {
  final String fitnessGoal;
  final double currentWeight;
  final double targetWeight;
  final double height;
  final String bodyType;
  final int targetCalories;
  final int targetProtein;
  final int targetCarbs;
  final int targetFat;
  final String activityLevel;
  final DateTime targetDate;

  const UserGoalsEntity({
    required this.fitnessGoal,
    required this.currentWeight,
    required this.targetWeight,
    required this.height,
    required this.bodyType,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
    required this.activityLevel,
    required this.targetDate,
  });

  @override
  List<Object?> get props => [
    fitnessGoal,
    currentWeight,
    targetWeight,
    height,
    bodyType,
    targetCalories,
    targetProtein,
    targetCarbs,
    targetFat,
    activityLevel,
    targetDate,
  ];

  double get bmi => currentWeight / ((height / 100) * (height / 100));
  double get targetBmi => targetWeight / ((height / 100) * (height / 100));
}

class UserPreferencesEntity extends Equatable {
  final List<String> dietaryPreferences;
  final List<String> workoutTypes;
  final List<String> availableEquipment;
  final int workoutDuration;
  final String difficultyLevel;
  final List<String> allergies;
  final bool notificationsEnabled;
  final String language;
  final String theme;

  const UserPreferencesEntity({
    required this.dietaryPreferences,
    required this.workoutTypes,
    required this.availableEquipment,
    required this.workoutDuration,
    required this.difficultyLevel,
    required this.allergies,
    required this.notificationsEnabled,
    required this.language,
    required this.theme,
  });

  @override
  List<Object?> get props => [
    dietaryPreferences,
    workoutTypes,
    availableEquipment,
    workoutDuration,
    difficultyLevel,
    allergies,
    notificationsEnabled,
    language,
    theme,
  ];
}
