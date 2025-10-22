class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final DateTime dateOfBirth;
  final double height; // in cm
  final double weight; // in kg
  final String gender;
  final String activityLevel;
  final List<String> fitnessGoals;
  final List<String> dietaryRestrictions;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.dateOfBirth,
    required this.height,
    required this.weight,
    required this.gender,
    required this.activityLevel,
    required this.fitnessGoals,
    required this.dietaryRestrictions,
    required this.createdAt,
    required this.updatedAt,
  });

  // Getters for calculated values
  double get bmi => weight / ((height / 100) * (height / 100));
  int get age => DateTime.now().year - dateOfBirth.year;
  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  // Factory constructors
  factory UserProfile.empty() {
    final now = DateTime.now();
    return UserProfile(
      id: '',
      name: '',
      email: '',
      dateOfBirth: now.subtract(
        const Duration(days: 365 * 25),
      ), // Default 25 years old
      height: 170.0,
      weight: 70.0,
      gender: 'Other',
      activityLevel: 'Moderate',
      fitnessGoals: [],
      dietaryRestrictions: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      height: (json['height'] ?? 170.0).toDouble(),
      weight: (json['weight'] ?? 70.0).toDouble(),
      gender: json['gender'] ?? 'Other',
      activityLevel: json['activity_level'] ?? 'Moderate',
      fitnessGoals: List<String>.from(json['fitness_goals'] ?? []),
      dietaryRestrictions: List<String>.from(
        json['dietary_restrictions'] ?? [],
      ),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'height': height,
      'weight': weight,
      'gender': gender,
      'activity_level': activityLevel,
      'fitness_goals': fitnessGoals,
      'dietary_restrictions': dietaryRestrictions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    DateTime? dateOfBirth,
    double? height,
    double? weight,
    String? gender,
    String? activityLevel,
    List<String>? fitnessGoals,
    List<String>? dietaryRestrictions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
