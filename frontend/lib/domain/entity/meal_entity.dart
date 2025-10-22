import 'package:equatable/equatable.dart';

class MealEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String type; // breakfast, lunch, dinner, snack
  final String? imageUrl;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  final int sugar;
  final int sodium;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTime; // in minutes
  final int cookTime; // in minutes
  final int servings;
  final List<String> dietaryTags; // vegetarian, vegan, gluten-free, etc.
  final List<String> allergens;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCustom;
  final String? createdBy;

  const MealEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.imageUrl,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.dietaryTags,
    required this.allergens,
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
    imageUrl,
    calories,
    protein,
    carbs,
    fat,
    fiber,
    sugar,
    sodium,
    ingredients,
    instructions,
    prepTime,
    cookTime,
    servings,
    dietaryTags,
    allergens,
    createdAt,
    updatedAt,
    isCustom,
    createdBy,
  ];

  double get proteinPercentage => (protein * 4) / calories * 100;
  double get carbsPercentage => (carbs * 4) / calories * 100;
  double get fatPercentage => (fat * 9) / calories * 100;
}

class MealPlanEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String userId;
  final List<MealDayEntity> days;
  final int totalDays;
  final int targetCalories;
  final String dietaryPreference;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const MealPlanEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    required this.days,
    required this.totalDays,
    required this.targetCalories,
    required this.dietaryPreference,
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
    totalDays,
    targetCalories,
    dietaryPreference,
    createdAt,
    updatedAt,
    isActive,
  ];
}

class MealDayEntity extends Equatable {
  final String id;
  final int dayNumber;
  final String date;
  final List<MealSlotEntity> meals;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;

  const MealDayEntity({
    required this.id,
    required this.dayNumber,
    required this.date,
    required this.meals,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  @override
  List<Object?> get props => [
    id,
    dayNumber,
    date,
    meals,
    totalCalories,
    totalProtein,
    totalCarbs,
    totalFat,
  ];
}

class MealSlotEntity extends Equatable {
  final String id;
  final String type; // breakfast, lunch, dinner, snack
  final String time;
  final List<MealItemEntity> items;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;

  const MealSlotEntity({
    required this.id,
    required this.type,
    required this.time,
    required this.items,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    time,
    items,
    totalCalories,
    totalProtein,
    totalCarbs,
    totalFat,
  ];
}

class MealItemEntity extends Equatable {
  final String id;
  final String mealId;
  final String name;
  final double quantity;
  final String unit;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final bool isLogged;
  final DateTime? loggedAt;

  const MealItemEntity({
    required this.id,
    required this.mealId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.isLogged = false,
    this.loggedAt,
  });

  @override
  List<Object?> get props => [
    id,
    mealId,
    name,
    quantity,
    unit,
    calories,
    protein,
    carbs,
    fat,
    isLogged,
    loggedAt,
  ];
}

class NutritionLogEntity extends Equatable {
  final String id;
  final String userId;
  final String mealId;
  final String mealName;
  final String mealType;
  final double quantity;
  final String unit;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final DateTime loggedAt;
  final String? notes;

  const NutritionLogEntity({
    required this.id,
    required this.userId,
    required this.mealId,
    required this.mealName,
    required this.mealType,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.loggedAt,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    mealId,
    mealName,
    mealType,
    quantity,
    unit,
    calories,
    protein,
    carbs,
    fat,
    loggedAt,
    notes,
  ];
}

class DailyNutritionEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;
  final int totalFiber;
  final int totalSugar;
  final int totalSodium;
  final int targetCalories;
  final int targetProtein;
  final int targetCarbs;
  final int targetFat;
  final List<NutritionLogEntity> logs;

  const DailyNutritionEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.totalFiber,
    required this.totalSugar,
    required this.totalSodium,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
    required this.logs,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    date,
    totalCalories,
    totalProtein,
    totalCarbs,
    totalFat,
    totalFiber,
    totalSugar,
    totalSodium,
    targetCalories,
    targetProtein,
    targetCarbs,
    targetFat,
    logs,
  ];

  double get caloriesProgress => totalCalories / targetCalories;
  double get proteinProgress => totalProtein / targetProtein;
  double get carbsProgress => totalCarbs / targetCarbs;
  double get fatProgress => totalFat / targetFat;
}
