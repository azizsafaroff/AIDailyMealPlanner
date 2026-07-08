import 'meal_plan_api_client.dart';
import 'mock_meal_plan_api_client.dart';
import 'openai_meal_plan_api_client.dart';

/// Set to true to use [MockMealPlanApiClient] (fully offline, no API key)
/// instead of calling OpenAI directly. Useful for UI development without
/// burning API credits.
const bool useMockApiClient = false;

MealPlanApiClient createMealPlanApiClient() =>
    useMockApiClient ? MockMealPlanApiClient() : OpenAiMealPlanApiClient();
