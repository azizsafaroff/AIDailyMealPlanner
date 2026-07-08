import 'dart:math';

import 'package:flutter/material.dart';

import '../models/daily_plan.dart';
import '../models/user_profile.dart';
import 'meal_plan_api_client.dart';
import 'mock_food_data.dart';

/// Placeholder implementation that fabricates a plausible [DailyPlan]
/// locally, respecting diet type, dislikes and allergies, so the whole app
/// is testable before a real proxy endpoint exists.
class MockMealPlanApiClient implements MealPlanApiClient {
  final Random _random;

  MockMealPlanApiClient({Random? random}) : _random = random ?? Random();

  @override
  Future<DailyPlan> generatePlan(UserProfile profile) => _build(profile);

  @override
  Future<DailyPlan> generateFullPlan(UserProfile profile) => _build(profile);

  @override
  Future<FoodItem> swapFood(SwapFoodContext context) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final slotIndex = context.mealIndex % allFoodPools.length;
    final pool = allFoodPools[min(slotIndex, allFoodPools.length - 1)];
    final existingNames = context.meal.foods.map((f) => f.name).toSet();
    final options = pool
        .where((f) => isFoodAllowed(f, context.profile))
        .where((f) => !existingNames.contains(f.name))
        .toList();
    final candidates = options.isNotEmpty ? options : pool;
    final pick = candidates[_random.nextInt(candidates.length)];
    return FoodItem(
      name: pick.name,
      amount: pick.amount,
      gramsEstimate: pick.gramsEstimate,
      glyph: pick.glyph,
    );
  }

  Future<DailyPlan> _build(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final slots = _slotsFor(profile.mealsPerDayPreference);
    final times = _spreadTimes(profile.wakeTime, profile.sleepTime, slots.length);

    final targetCalories = _targetCalories(profile);
    final weights = _weightsFor(slots);
    final weightSum = weights.fold<double>(0, (a, b) => a + b);

    final schedule = <MealEntry>[];
    for (var i = 0; i < slots.length; i++) {
      final slot = slots[i];
      final pool = _poolFor(slot);
      final allowed = pool.where((f) => isFoodAllowed(f, profile)).toList();
      final candidates = allowed.isNotEmpty ? allowed : pool;
      candidates.shuffle(_random);
      final count = slot == 'Snack' || slot == 'Before bed' ? 2 : 4;
      final picked = candidates.take(min(count, candidates.length)).toList();
      final foods = picked
          .map((f) => FoodItem(
                name: f.name,
                amount: f.amount,
                gramsEstimate: f.gramsEstimate,
                glyph: f.glyph,
              ))
          .toList();
      final mealCalories = (targetCalories * (weights[i] / weightSum)).round();

      schedule.add(MealEntry(
        time: times[i],
        meal: slot,
        estimatedCalories: mealCalories,
        foods: foods,
      ));
    }

    final protein = (profile.goal == Goal.buildMuscle ? profile.weightKg * 2.0 : profile.weightKg * 1.6).round();
    final fat = (targetCalories * 0.25 / 9).round();
    final carbCalories = targetCalories - (protein * 4) - (fat * 9);
    final carbs = max(80, (carbCalories / 4).round());
    final water = (profile.weightKg * 0.035).clamp(1.8, 4.0);

    return DailyPlan(
      goal: profile.goal.label,
      profileSummary: ProfileSummary(
        gender: profile.gender.label,
        dietType: profile.dietType.label,
        country: profile.country,
        mealCountPreference: profile.mealsPerDayPreference.label,
      ),
      dailyTargets: DailyTargets(
        calories: '${targetCalories - 100}-${targetCalories + 100} kcal',
        protein: '${protein - 10}-${protein + 10} g',
        carbs: '${carbs - 20}-${carbs + 20} g',
        fat: '${fat - 10}-${fat + 10} g',
        water: '${water.toStringAsFixed(1)}-${(water + 0.5).toStringAsFixed(1)} L',
      ),
      schedule: schedule,
      disclaimer:
          'This is a general suggestion, not medical advice. Consult a professional if you have a medical condition.',
    );
  }

  List<String> _slotsFor(MealsPerDayPreference pref) => switch (pref) {
        MealsPerDayPreference.threeMeals => const ['Breakfast', 'Lunch', 'Dinner'],
        MealsPerDayPreference.threeMealsPlusSnacks => const [
            'Breakfast',
            'Snack',
            'Lunch',
            'Snack',
            'Dinner',
          ],
        MealsPerDayPreference.flexible => const [
            'Breakfast',
            'Snack',
            'Lunch',
            'Snack',
            'Dinner',
            'Before bed',
          ],
      };

  List<double> _weightsFor(List<String> slots) => slots
      .map((s) => switch (s) {
            'Breakfast' => 0.25,
            'Lunch' => 0.32,
            'Dinner' => 0.28,
            _ => 0.10,
          })
      .toList();

  List<FoodTemplate> _poolFor(String slot) => switch (slot) {
        'Breakfast' => breakfastFoods,
        'Lunch' => lunchFoods,
        'Dinner' => dinnerFoods,
        _ => snackFoods,
      };

  List<String> _spreadTimes(TimeOfDay wake, TimeOfDay sleep, int count) {
    final wakeMinutes = wake.hour * 60 + wake.minute;
    var sleepMinutes = sleep.hour * 60 + sleep.minute;
    if (sleepMinutes <= wakeMinutes) sleepMinutes += 24 * 60;
    final span = sleepMinutes - wakeMinutes;
    final step = span / (count + 1);

    return List.generate(count, (i) {
      final minutesFromWake = (step * (i + 1)).round();
      var totalMinutes = (wakeMinutes + minutesFromWake) % (24 * 60);
      final h = totalMinutes ~/ 60;
      final m = totalMinutes % 60;
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    });
  }

  int _targetCalories(UserProfile profile) {
    double base = profile.weightKg * 24;
    base *= switch (profile.exerciseLevel) {
      ExerciseLevel.none => 0.95,
      ExerciseLevel.sometimes => 1.0,
      ExerciseLevel.threeToFive => 1.1,
    };
    base *= switch (profile.goal) {
      Goal.loseFat => 0.85,
      Goal.buildMuscle => 1.15,
      Goal.gainWeight => 1.2,
      Goal.stayHealthy => 1.0,
    };
    return (base / 10).round() * 10;
  }
}
