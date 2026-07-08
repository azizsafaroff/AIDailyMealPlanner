import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_daily_meal_planner/logic/app_service.dart';
import 'package:ai_daily_meal_planner/logic/storage_service.dart';
import 'package:ai_daily_meal_planner/models/daily_plan.dart';

String _timeAgo(Duration d) {
  final t = DateTime.now().subtract(d);
  return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

MealEntry _meal(String time) => MealEntry(
      time: time,
      meal: 'Meal $time',
      estimatedCalories: 100,
      foods: const [],
    );

void main() {
  test('currentMealIndex picks the most recently started meal, not the earliest', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.create();
    final service = AppService(storage: storage);

    // Meals 2h ago, 30min ago, and 1h in the future (relative to "now").
    final plan = DailyPlan(
      goal: 'Stay healthy',
      profileSummary: const ProfileSummary(
        gender: 'Other',
        dietType: 'None',
        country: 'US',
        mealCountPreference: 'Flexible',
      ),
      dailyTargets: const DailyTargets(
        calories: '2000 kcal',
        protein: '100 g',
        carbs: '200 g',
        fat: '60 g',
        water: '2.5 L',
      ),
      schedule: [
        _meal(_timeAgo(const Duration(hours: 2))),
        _meal(_timeAgo(const Duration(minutes: 30))),
        _meal(_timeAgo(const Duration(hours: -1))), // 1h in the future
      ],
      disclaimer: '',
    );

    // The 30-min-ago meal (index 1) is the most recently started one —
    // not the 2-hours-ago meal (index 0), which is what the old buggy
    // "largest diff" comparison would have picked.
    expect(service.currentMealIndex(plan), 1);
  });
}
