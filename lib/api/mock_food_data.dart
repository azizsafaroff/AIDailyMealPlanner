import '../models/user_profile.dart';

/// A candidate food used only by [MockMealPlanApiClient] to assemble
/// placeholder plans. [excludedDiets] lists the diet types this food is
/// NOT suitable for. [glyph] is a single emoji, matching what the AI would
/// generate for a food card's icon.
class FoodTemplate {
  final String name;
  final String amount;
  final String gramsEstimate;
  final int calories;
  final String glyph;
  final Set<DietType> excludedDiets;

  const FoodTemplate({
    required this.name,
    required this.amount,
    required this.gramsEstimate,
    required this.calories,
    required this.glyph,
    this.excludedDiets = const {},
  });
}

const _meat = {DietType.vegetarian, DietType.vegan};
const _fish = {DietType.vegan};
const _dairyEgg = {DietType.vegan};
const _pork = {
  DietType.vegetarian,
  DietType.vegan,
  DietType.halal,
  DietType.kosher,
  DietType.noPork,
};

const breakfastFoods = <FoodTemplate>[
  FoodTemplate(name: 'Eggs', amount: '4', gramsEstimate: '220 g', calories: 280, glyph: '🥚', excludedDiets: _dairyEgg),
  FoodTemplate(name: 'Egg whites', amount: '6', gramsEstimate: '210 g', calories: 150, glyph: '🍳', excludedDiets: _dairyEgg),
  FoodTemplate(name: 'Oats', amount: '60 g', gramsEstimate: '60 g', calories: 230, glyph: '🥣'),
  FoodTemplate(name: 'Greek yogurt', amount: '1 cup', gramsEstimate: '245 g', calories: 150, glyph: '🥛', excludedDiets: _dairyEgg),
  FoodTemplate(name: 'Blueberries', amount: '1 cup', gramsEstimate: '150 g', calories: 85, glyph: '🫐'),
  FoodTemplate(name: 'Banana', amount: '1', gramsEstimate: '120 g', calories: 105, glyph: '🍌'),
  FoodTemplate(name: 'Turkey bacon', amount: '3 strips', gramsEstimate: '60 g', calories: 120, glyph: '🥓', excludedDiets: _meat),
  FoodTemplate(name: 'Pork sausage', amount: '2 links', gramsEstimate: '90 g', calories: 210, glyph: '🌭', excludedDiets: _pork),
  FoodTemplate(name: 'Tofu scramble', amount: '200 g', gramsEstimate: '200 g', calories: 180, glyph: '🧊'),
  FoodTemplate(name: 'Whole wheat toast', amount: '2 slices', gramsEstimate: '70 g', calories: 160, glyph: '🍞'),
  FoodTemplate(name: 'Avocado', amount: '½', gramsEstimate: '75 g', calories: 120, glyph: '🥑'),
  FoodTemplate(name: 'Coffee', amount: '1 mug', gramsEstimate: '250 ml', calories: 5, glyph: '☕'),
];

const lunchFoods = <FoodTemplate>[
  FoodTemplate(name: 'Chicken breast', amount: '200 g', gramsEstimate: '200 g', calories: 330, glyph: '🍗', excludedDiets: _meat),
  FoodTemplate(name: 'Grilled salmon', amount: '180 g', gramsEstimate: '180 g', calories: 370, glyph: '🐟', excludedDiets: _fish),
  FoodTemplate(name: 'Shrimp', amount: '150 g', gramsEstimate: '150 g', calories: 170, glyph: '🍤', excludedDiets: _fish),
  FoodTemplate(name: 'Falafel', amount: '5', gramsEstimate: '150 g', calories: 280, glyph: '🧆'),
  FoodTemplate(name: 'Black beans', amount: '150 g', gramsEstimate: '150 g', calories: 190, glyph: '🫘'),
  FoodTemplate(name: 'Chickpeas', amount: '150 g', gramsEstimate: '150 g', calories: 210, glyph: '🫘'),
  FoodTemplate(name: 'Brown rice', amount: '150 g', gramsEstimate: '150 g', calories: 200, glyph: '🍚'),
  FoodTemplate(name: 'Quinoa', amount: '150 g', gramsEstimate: '150 g', calories: 220, glyph: '🍚'),
  FoodTemplate(name: 'Broccoli', amount: '1 cup', gramsEstimate: '90 g', calories: 30, glyph: '🥦'),
  FoodTemplate(name: 'Mixed greens salad', amount: '2 cups', gramsEstimate: '120 g', calories: 40, glyph: '🥗'),
  FoodTemplate(name: 'Olive oil', amount: '1 tbsp', gramsEstimate: '14 g', calories: 120, glyph: '🫒'),
  FoodTemplate(name: 'Beef strips', amount: '180 g', gramsEstimate: '180 g', calories: 350, glyph: '🥩', excludedDiets: _meat),
];

const dinnerFoods = <FoodTemplate>[
  FoodTemplate(name: 'Salmon fillet', amount: '180 g', gramsEstimate: '180 g', calories: 370, glyph: '🐟', excludedDiets: _fish),
  FoodTemplate(name: 'Grilled chicken thigh', amount: '200 g', gramsEstimate: '200 g', calories: 360, glyph: '🍗', excludedDiets: _meat),
  FoodTemplate(name: 'Lentil stew', amount: '250 g', gramsEstimate: '250 g', calories: 280, glyph: '🍲'),
  FoodTemplate(name: 'Tofu stir-fry', amount: '220 g', gramsEstimate: '220 g', calories: 260, glyph: '🥘'),
  FoodTemplate(name: 'Sweet potato', amount: '1 medium', gramsEstimate: '150 g', calories: 130, glyph: '🍠'),
  FoodTemplate(name: 'Roasted vegetables', amount: '1 cup', gramsEstimate: '150 g', calories: 90, glyph: '🥕'),
  FoodTemplate(name: 'Asparagus', amount: '8 spears', gramsEstimate: '120 g', calories: 30, glyph: '🌿'),
  FoodTemplate(name: 'Whole wheat pasta', amount: '150 g', gramsEstimate: '150 g', calories: 220, glyph: '🍝'),
  FoodTemplate(name: 'Turkey meatballs', amount: '6', gramsEstimate: '180 g', calories: 300, glyph: '🦃', excludedDiets: _meat),
  FoodTemplate(name: 'Lamb kofta', amount: '4', gramsEstimate: '180 g', calories: 340, glyph: '🍢', excludedDiets: _meat),
];

const snackFoods = <FoodTemplate>[
  FoodTemplate(name: 'Almonds', amount: '20 g', gramsEstimate: '20 g', calories: 120, glyph: '🥜'),
  FoodTemplate(name: 'Walnuts', amount: '15 g', gramsEstimate: '15 g', calories: 100, glyph: '🌰'),
  FoodTemplate(name: 'Apple', amount: '1 medium', gramsEstimate: '180 g', calories: 95, glyph: '🍎'),
  FoodTemplate(name: 'Peanut butter', amount: '1 tbsp', gramsEstimate: '16 g', calories: 95, glyph: '🥜'),
  FoodTemplate(name: 'Cottage cheese', amount: '1 cup', gramsEstimate: '225 g', calories: 180, glyph: '🧀', excludedDiets: _dairyEgg),
  FoodTemplate(name: 'Hummus', amount: '3 tbsp', gramsEstimate: '45 g', calories: 100, glyph: '🫘'),
  FoodTemplate(name: 'Carrot sticks', amount: '1 cup', gramsEstimate: '110 g', calories: 40, glyph: '🥕'),
  FoodTemplate(name: 'Protein shake', amount: '1 scoop', gramsEstimate: '30 g', calories: 130, glyph: '🥤'),
  FoodTemplate(name: 'Dried apricots', amount: '6', gramsEstimate: '40 g', calories: 100, glyph: '🍑'),
];

const allFoodPools = [breakfastFoods, lunchFoods, dinnerFoods, snackFoods];

bool isFoodAllowed(FoodTemplate food, UserProfile profile) {
  if (food.excludedDiets.contains(profile.dietType)) return false;
  final lowerName = food.name.toLowerCase();
  for (final disliked in profile.dislikedFoods) {
    if (disliked.trim().isEmpty) continue;
    if (lowerName.contains(disliked.toLowerCase())) return false;
  }
  for (final allergic in profile.allergicFoods) {
    if (allergic.trim().isEmpty) continue;
    if (lowerName.contains(allergic.toLowerCase())) return false;
  }
  return true;
}
