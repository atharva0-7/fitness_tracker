import 'package:equatable/equatable.dart';

class WorkoutEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String type;
  final String difficulty;
  final List<String> bodyParts;
  final int duration; // in minutes
  final int caloriesBurned;
  final String? imageUrl;
  final String? videoUrl;
  final List<ExerciseEntity> exercises;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCustom;
  final String? createdBy;

  const WorkoutEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.bodyParts,
    required this.duration,
    required this.caloriesBurned,
    this.imageUrl,
    this.videoUrl,
    required this.exercises,
    required this.createdAt,
    required this.updatedAt,
    this.isCustom = false,
    this.createdBy,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    difficulty,
    bodyParts,
    duration,
    caloriesBurned,
    imageUrl,
    videoUrl,
    exercises,
    createdAt,
    updatedAt,
    isCustom,
    createdBy,
  ];
}

class ExerciseEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final String? imageUrl;
  final String? videoUrl;
  final List<String> instructions;
  final List<String> tips;
  final List<String> muscles;
  final String equipment;
  final ExerciseType type;

  const ExerciseEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.imageUrl,
    this.videoUrl,
    required this.instructions,
    required this.tips,
    required this.muscles,
    required this.equipment,
    required this.type,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    category,
    imageUrl,
    videoUrl,
    instructions,
    tips,
    muscles,
    equipment,
    type,
  ];
}

class WorkoutSetEntity extends Equatable {
  final String id;
  final String exerciseId;
  final int reps;
  final double? weight;
  final int? duration; // in seconds
  final int? distance; // in meters
  final int restTime; // in seconds
  final String? notes;
  final bool isCompleted;

  const WorkoutSetEntity({
    required this.id,
    required this.exerciseId,
    required this.reps,
    this.weight,
    this.duration,
    this.distance,
    required this.restTime,
    this.notes,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [
    id,
    exerciseId,
    reps,
    weight,
    duration,
    distance,
    restTime,
    notes,
    isCompleted,
  ];
}

class WorkoutSessionEntity extends Equatable {
  final String id;
  final String workoutId;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int? duration; // in minutes
  final int? caloriesBurned;
  final List<WorkoutSetEntity> sets;
  final String? notes;
  final WorkoutStatus status;

  const WorkoutSessionEntity({
    required this.id,
    required this.workoutId,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.duration,
    this.caloriesBurned,
    required this.sets,
    this.notes,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    workoutId,
    userId,
    startTime,
    endTime,
    duration,
    caloriesBurned,
    sets,
    notes,
    status,
  ];
}

class WorkoutPlanEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String userId;
  final List<WorkoutDayEntity> days;
  final int totalWeeks;
  final String difficulty;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const WorkoutPlanEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    required this.days,
    required this.totalWeeks,
    required this.difficulty,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    userId,
    days,
    totalWeeks,
    difficulty,
    createdAt,
    updatedAt,
    isActive,
  ];
}

class WorkoutDayEntity extends Equatable {
  final String id;
  final int dayNumber;
  final String name;
  final List<String> workoutIds;
  final bool isRestDay;
  final String? notes;

  const WorkoutDayEntity({
    required this.id,
    required this.dayNumber,
    required this.name,
    required this.workoutIds,
    this.isRestDay = false,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    dayNumber,
    name,
    workoutIds,
    isRestDay,
    notes,
  ];
}

enum ExerciseType { strength, cardio, flexibility, balance, plyometric }

enum WorkoutStatus { notStarted, inProgress, completed, paused, cancelled }
