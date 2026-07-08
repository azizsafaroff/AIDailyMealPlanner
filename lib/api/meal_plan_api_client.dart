import '../models/daily_plan.dart';
import '../models/user_profile.dart';

/// Everything the API needs to generate a single replacement food for one
/// slot in the current plan.
class SwapFoodContext {
  final UserProfile profile;
  final DailyPlan currentPlan;
  final int mealIndex;
  final int foodIndex;

  const SwapFoodContext({
    required this.profile,
    required this.currentPlan,
    required this.mealIndex,
    required this.foodIndex,
  });

  MealEntry get meal => currentPlan.schedule[mealIndex];
  FoodItem get food => meal.foods[foodIndex];
}

/// Client interface for talking to the AI meal-plan proxy. Every request
/// implicitly carries [UserProfile.dislikedFoods] and
/// [UserProfile.allergicFoods] as hard/soft exclusions.
abstract class MealPlanApiClient {
  /// Generates today's very first plan (onboarding, or day rollover).
  Future<DailyPlan> generatePlan(UserProfile profile);

  /// Regenerates the entire day's plan from scratch (Regenerate button,
  /// profile-triggered regeneration).
  Future<DailyPlan> generateFullPlan(UserProfile profile);

  /// Generates one replacement food for the slot described by [context].
  Future<FoodItem> swapFood(SwapFoodContext context);
}
