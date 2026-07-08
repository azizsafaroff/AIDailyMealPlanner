/// Fallback keyword lookup for [FoodItem.glyph], used only when a food has
/// no glyph of its own — i.e. plans saved before the AI started generating
/// one. New plans get their glyph directly from the API response.
const Map<String, String> _foodGlyphs = {
  'egg': '🥚',
  'egg white': '🍳',
  'oats': '🥣',
  'yogurt': '🥛',
  'blueberr': '🫐',
  'banana': '🍌',
  'bacon': '🥓',
  'tofu': '🧊',
  'toast': '🍞',
  'avocado': '🥑',
  'coffee': '☕',
  'chicken': '🍗',
  'salmon': '🐟',
  'shrimp': '🍤',
  'falafel': '🧆',
  'black bean': '🫘',
  'chickpea': '🫘',
  'rice': '🍚',
  'quinoa': '🍚',
  'broccoli': '🥦',
  'salad': '🥗',
  'greens': '🥗',
  'olive oil': '🫒',
  'beef': '🥩',
  'lentil': '🍲',
  'sweet potato': '🍠',
  'potato': '🥔',
  'vegetable': '🥕',
  'asparagus': '🌿',
  'pasta': '🍝',
  'turkey': '🦃',
  'lamb': '🍢',
  'almond': '🥜',
  'walnut': '🌰',
  'apple': '🍎',
  'peanut butter': '🥜',
  'cottage cheese': '🧀',
  'hummus': '🫘',
  'carrot': '🥕',
  'protein shake': '🥤',
  'apricot': '🍑',
  'water': '💧',
};

String foodGlyph(String name) {
  final lower = name.toLowerCase();
  for (final entry in _foodGlyphs.entries) {
    if (lower.contains(entry.key)) return entry.value;
  }
  return '🍽️';
}
