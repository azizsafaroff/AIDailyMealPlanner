import 'package:flutter/material.dart';

enum Gender { male, female, other }

extension GenderX on Gender {
  String get label => switch (this) {
        Gender.male => 'Male',
        Gender.female => 'Female',
        Gender.other => 'Other',
      };
}

enum Goal { loseFat, buildMuscle, stayHealthy, gainWeight }

extension GoalX on Goal {
  String get label => switch (this) {
        Goal.loseFat => 'Lose fat',
        Goal.buildMuscle => 'Build muscle',
        Goal.stayHealthy => 'Stay healthy',
        Goal.gainWeight => 'Gain weight',
      };

  String get emoji => switch (this) {
        Goal.loseFat => '🔥',
        Goal.buildMuscle => '💪',
        Goal.stayHealthy => '⚖️',
        Goal.gainWeight => '📈',
      };
}

enum ExerciseLevel { none, sometimes, threeToFive }

extension ExerciseLevelX on ExerciseLevel {
  String get label => switch (this) {
        ExerciseLevel.none => 'No exercise',
        ExerciseLevel.sometimes => 'Sometimes',
        ExerciseLevel.threeToFive => '3-5 times a week',
      };

  String get emoji => switch (this) {
        ExerciseLevel.none => '🛋️',
        ExerciseLevel.sometimes => '🚶',
        ExerciseLevel.threeToFive => '🏋️',
      };
}

enum DietType { none, vegetarian, vegan, halal, kosher, noPork }

extension DietTypeX on DietType {
  String get label => switch (this) {
        DietType.none => 'None',
        DietType.vegetarian => 'Vegetarian',
        DietType.vegan => 'Vegan',
        DietType.halal => 'Halal',
        DietType.kosher => 'Kosher',
        DietType.noPork => 'No pork',
      };
}

enum MealsPerDayPreference { threeMeals, threeMealsPlusSnacks, flexible }

extension MealsPerDayPreferenceX on MealsPerDayPreference {
  String get label => switch (this) {
        MealsPerDayPreference.threeMeals => '3 meals',
        MealsPerDayPreference.threeMealsPlusSnacks => '3 meals + snacks',
        MealsPerDayPreference.flexible => 'Flexible',
      };
}

enum Budget { cheap, medium, noLimit }

extension BudgetX on Budget {
  String get label => switch (this) {
        Budget.cheap => 'Cheap',
        Budget.medium => 'Medium',
        Budget.noLimit => 'No limit',
      };

  String get emoji => switch (this) {
        Budget.cheap => '💵',
        Budget.medium => '💳',
        Budget.noLimit => '💎',
      };
}

String timeOfDayToJson(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

TimeOfDay timeOfDayFromJson(String s) {
  final parts = s.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

class UserProfile {
  final int age;
  final int heightCm;
  final int weightKg;
  final Gender gender;
  final Goal goal;
  final ExerciseLevel exerciseLevel;
  final TimeOfDay wakeTime;
  final TimeOfDay sleepTime;
  final String country;
  final DietType dietType;
  final MealsPerDayPreference mealsPerDayPreference;
  final Budget budget;
  final List<String> dislikedFoods;
  final List<String> allergicFoods;

  const UserProfile({
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.gender,
    required this.goal,
    required this.exerciseLevel,
    required this.wakeTime,
    required this.sleepTime,
    required this.country,
    required this.dietType,
    required this.mealsPerDayPreference,
    required this.budget,
    this.dislikedFoods = const [],
    this.allergicFoods = const [],
  });

  static const defaultProfile = UserProfile(
    age: 28,
    heightCm: 175,
    weightKg: 70,
    gender: Gender.other,
    goal: Goal.stayHealthy,
    exerciseLevel: ExerciseLevel.sometimes,
    wakeTime: TimeOfDay(hour: 7, minute: 0),
    sleepTime: TimeOfDay(hour: 23, minute: 0),
    country: '',
    dietType: DietType.none,
    mealsPerDayPreference: MealsPerDayPreference.threeMeals,
    budget: Budget.medium,
  );

  UserProfile copyWith({
    int? age,
    int? heightCm,
    int? weightKg,
    Gender? gender,
    Goal? goal,
    ExerciseLevel? exerciseLevel,
    TimeOfDay? wakeTime,
    TimeOfDay? sleepTime,
    String? country,
    DietType? dietType,
    MealsPerDayPreference? mealsPerDayPreference,
    Budget? budget,
    List<String>? dislikedFoods,
    List<String>? allergicFoods,
  }) {
    return UserProfile(
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      goal: goal ?? this.goal,
      exerciseLevel: exerciseLevel ?? this.exerciseLevel,
      wakeTime: wakeTime ?? this.wakeTime,
      sleepTime: sleepTime ?? this.sleepTime,
      country: country ?? this.country,
      dietType: dietType ?? this.dietType,
      mealsPerDayPreference: mealsPerDayPreference ?? this.mealsPerDayPreference,
      budget: budget ?? this.budget,
      dislikedFoods: dislikedFoods ?? this.dislikedFoods,
      allergicFoods: allergicFoods ?? this.allergicFoods,
    );
  }

  Map<String, dynamic> toJson() => {
        'age': age,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'gender': gender.name,
        'goal': goal.name,
        'exerciseLevel': exerciseLevel.name,
        'wakeTime': timeOfDayToJson(wakeTime),
        'sleepTime': timeOfDayToJson(sleepTime),
        'country': country,
        'dietType': dietType.name,
        'mealsPerDayPreference': mealsPerDayPreference.name,
        'budget': budget.name,
        'dislikedFoods': dislikedFoods,
        'allergicFoods': allergicFoods,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        age: json['age'] as int,
        heightCm: json['heightCm'] as int,
        weightKg: json['weightKg'] as int,
        gender: Gender.values.byName(json['gender'] as String),
        goal: Goal.values.byName(json['goal'] as String),
        exerciseLevel: ExerciseLevel.values.byName(json['exerciseLevel'] as String),
        wakeTime: timeOfDayFromJson(json['wakeTime'] as String),
        sleepTime: timeOfDayFromJson(json['sleepTime'] as String),
        country: json['country'] as String,
        dietType: DietType.values.byName(json['dietType'] as String),
        mealsPerDayPreference:
            MealsPerDayPreference.values.byName(json['mealsPerDayPreference'] as String),
        budget: Budget.values.byName(json['budget'] as String),
        dislikedFoods: (json['dislikedFoods'] as List?)?.cast<String>() ?? const [],
        allergicFoods: (json['allergicFoods'] as List?)?.cast<String>() ?? const [],
      );
}
