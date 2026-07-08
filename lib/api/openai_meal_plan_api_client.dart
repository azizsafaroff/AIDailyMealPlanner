import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/daily_plan.dart';
import '../models/user_profile.dart';
import 'meal_plan_api_client.dart';

const String _mealPlanDisclaimer =
    'This is a general suggestion, not medical advice. Consult a professional if you have a medical condition.';

const String _chatCompletionsUrl = 'https://api.openai.com/v1/chat/completions';

/// Model used for meal plan generation and food swaps. Change here if you
/// want a different quality/cost tradeoff.
const String _model = 'gpt-4o-mini';

const String _planSystemPrompt = '''
You are a professional nutrition planning assistant embedded in a mobile app.
Generate ONE day's meal plan for the given user profile as a single strict
JSON object with EXACTLY this shape (no extra keys, no markdown, no prose):

{
  "goal": "<human-readable goal, e.g. 'Build Muscle'>",
  "profile_summary": {
    "gender": "<string>",
    "diet_type": "<string>",
    "country": "<string>",
    "meal_count_preference": "<string>"
  },
  "daily_targets": {
    "calories": "<range like '2800-3000 kcal'>",
    "protein": "<range like '140-160 g'>",
    "carbs": "<range like '320-360 g'>",
    "fat": "<range like '70-90 g'>",
    "water": "<range like '2.5-3 L'>"
  },
  "schedule": [
    {
      "time": "HH:MM",
      "meal": "<Breakfast|Lunch|Dinner|Snack|Before bed|...>",
      "estimated_calories": <integer>,
      "foods": [
        {"name": "<food name>", "amount": "<quantity, e.g. '4' or '200 g'>", "grams_estimate": "<approx grams, e.g. '220 g'>", "glyph": "<single emoji representing the food, e.g. '🥚'>"}
      ]
    }
  ]
}

Rules:
- The number of schedule entries and their spacing must match meals_per_day_preference and fit between wake_time and sleep_time.
- Respect diet_type strictly (vegetarian/vegan/halal/kosher/no_pork/none).
- NEVER include any food listed in allergic_foods — this is a hard safety exclusion.
- Avoid any food listed in disliked_foods.
- Calorie/macro targets should be realistic for the user's age, height, weight, gender, goal and exercise level.
- "glyph" must be EXACTLY one emoji character that best visually represents that specific food (e.g. 🥚 for eggs, 🍗 for chicken, 🥦 for broccoli) — not a generic plate icon.
- Output ONLY the JSON object, nothing else.
''';

const String _swapSystemPrompt = '''
You are a nutrition planning assistant. The user wants to replace ONE food
item in an existing meal. Respond with a single strict JSON object with
EXACTLY this shape, nothing else:

{"name": "<food name>", "amount": "<quantity, e.g. '4' or '200 g'>", "grams_estimate": "<approx grams, e.g. '220 g'>", "glyph": "<single emoji representing the food, e.g. '🥚'>"}

Rules:
- The replacement must fit the given meal's time/type and be different from the other foods already in that meal.
- Respect diet_type strictly.
- NEVER suggest any food listed in allergic_foods — this is a hard safety exclusion.
- Avoid any food listed in disliked_foods.
- "glyph" must be EXACTLY one emoji character that best visually represents that specific food — not a generic plate icon.
- Output ONLY the JSON object.
''';

/// Calls the OpenAI Chat Completions API directly from the client using
/// the API key in `.env` (`OPENAI_API_KEY`), the same pattern used by the
/// AudioScript app. There is no backend proxy in this app.
class OpenAiMealPlanApiClient implements MealPlanApiClient {
  final http.Client _client;

  OpenAiMealPlanApiClient({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<DailyPlan> generatePlan(UserProfile profile) => _generate(profile);

  @override
  Future<DailyPlan> generateFullPlan(UserProfile profile) => _generate(profile);

  @override
  Future<FoodItem> swapFood(SwapFoodContext context) async {
    final userPrompt = jsonEncode({
      'profile': _profileJson(context.profile),
      'meal': {
        'time': context.meal.time,
        'name': context.meal.meal,
        'other_foods_in_meal': context.meal.foods
            .where((f) => f.name != context.food.name)
            .map((f) => f.name)
            .toList(),
      },
      'food_to_replace': context.food.name,
    });

    final content = await _chat(
      systemPrompt: _swapSystemPrompt,
      userPrompt: userPrompt,
      timeout: const Duration(seconds: 25),
    );

    final decoded = jsonDecode(content) as Map<String, dynamic>;
    return FoodItem.fromJson(decoded);
  }

  Future<DailyPlan> _generate(UserProfile profile) async {
    final userPrompt = jsonEncode(_profileJson(profile));

    final content = await _chat(
      systemPrompt: _planSystemPrompt,
      userPrompt: userPrompt,
      timeout: const Duration(seconds: 45),
    );

    final decoded = jsonDecode(content) as Map<String, dynamic>;
    decoded['disclaimer'] = _mealPlanDisclaimer;
    return DailyPlan.fromJson(decoded);
  }

  Map<String, dynamic> _profileJson(UserProfile profile) => {
        'age': profile.age,
        'height_cm': profile.heightCm,
        'weight_kg': profile.weightKg,
        'gender': profile.gender.label,
        'goal': profile.goal.label,
        'exercise_level': profile.exerciseLevel.label,
        'wake_time': timeOfDayToJson(profile.wakeTime),
        'sleep_time': timeOfDayToJson(profile.sleepTime),
        'country': profile.country,
        'diet_type': profile.dietType.label,
        'meals_per_day_preference': profile.mealsPerDayPreference.label,
        'budget': profile.budget.label,
        'disliked_foods': profile.dislikedFoods,
        'allergic_foods': profile.allergicFoods,
      };

  Future<String> _chat({
    required String systemPrompt,
    required String userPrompt,
    required Duration timeout,
  }) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'sk-your-key-here') {
      throw Exception('Missing OPENAI_API_KEY — set it in .env');
    }

    final response = await _client
        .post(
          Uri.parse(_chatCompletionsUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': _model,
            'messages': [
              {'role': 'system', 'content': systemPrompt},
              {'role': 'user', 'content': userPrompt},
            ],
            'response_format': {'type': 'json_object'},
            'temperature': 0.8,
          }),
        )
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception('OpenAI error ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = decoded['choices'] as List;
    final message = choices.first['message'] as Map<String, dynamic>;
    return message['content'] as String;
  }
}
