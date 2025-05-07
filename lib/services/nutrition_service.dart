import '../models/nutrition.dart';

/// Service class that handles nutrition data lookups
/// Now using locally defined nutrition data instead of requiring an external API
class NutritionService {
  // We're no longer using these keys since we're implementing local nutrition data
  final String appId = 'YOUR_APP_ID';
  final String appKey = 'YOUR_APP_KEY';

  // Nutrition database - contains calories and macros for common foods per 100g
  final Map<String, Map<String, dynamic>> nutritionDatabase = {
    // Fruits
    'apple': {
      'calories': 52,
      'protein': 0.3,
      'carbs': 14,
      'fat': 0.2,
      'fiber': 2.4,
      'sugar': 10.4,
      'unit': 'medium',
      'weight': 182,
    },
    'banana': {
      'calories': 89,
      'protein': 1.1,
      'carbs': 22.8,
      'fat': 0.3,
      'fiber': 2.6,
      'sugar': 12.2,
      'unit': 'medium',
      'weight': 118,
    },
    'orange': {
      'calories': 47,
      'protein': 0.9,
      'carbs': 11.8,
      'fat': 0.1,
      'fiber': 2.4,
      'sugar': 9.4,
      'unit': 'medium',
      'weight': 131,
    },
    'strawberry': {
      'calories': 32,
      'protein': 0.7,
      'carbs': 7.7,
      'fat': 0.3,
      'fiber': 2.0,
      'sugar': 4.9,
      'unit': 'cup',
      'weight': 152,
    },
    'blueberry': {
      'calories': 57,
      'protein': 0.7,
      'carbs': 14.5,
      'fat': 0.3,
      'fiber': 2.4,
      'sugar': 10,
      'unit': 'cup',
      'weight': 148,
    },
    'grape': {
      'calories': 62,
      'protein': 0.6,
      'carbs': 16,
      'fat': 0.3,
      'fiber': 0.8,
      'sugar': 15,
      'unit': 'cup',
      'weight': 92,
    },

    // Vegetables
    'carrot': {
      'calories': 41,
      'protein': 0.9,
      'carbs': 9.6,
      'fat': 0.2,
      'fiber': 2.8,
      'sugar': 4.7,
      'unit': 'medium',
      'weight': 61,
    },
    'broccoli': {
      'calories': 31,
      'protein': 2.6,
      'carbs': 6,
      'fat': 0.3,
      'fiber': 2.4,
      'sugar': 1.5,
      'unit': 'cup',
      'weight': 91,
    },
    'spinach': {
      'calories': 23,
      'protein': 2.9,
      'carbs': 3.6,
      'fat': 0.4,
      'fiber': 2.2,
      'sugar': 0.4,
      'unit': 'cup',
      'weight': 30,
    },
    'potato': {
      'calories': 163,
      'protein': 4.3,
      'carbs': 37,
      'fat': 0.2,
      'fiber': 3.8,
      'sugar': 1.3,
      'unit': 'medium',
      'weight': 173,
    },
    'tomato': {
      'calories': 22,
      'protein': 1.1,
      'carbs': 4.8,
      'fat': 0.2,
      'fiber': 1.5,
      'sugar': 3.2,
      'unit': 'medium',
      'weight': 123,
    },
    'onion': {
      'calories': 40,
      'protein': 1.1,
      'carbs': 9.3,
      'fat': 0.1,
      'fiber': 1.7,
      'sugar': 4.2,
      'unit': 'medium',
      'weight': 110,
    },

    // Proteins
    'chicken breast': {
      'calories': 165,
      'protein': 31,
      'carbs': 0,
      'fat': 3.6,
      'fiber': 0,
      'sugar': 0,
      'unit': '100g',
      'weight': 100,
    },
    'beef': {
      'calories': 250,
      'protein': 26,
      'carbs': 0,
      'fat': 17,
      'fiber': 0,
      'sugar': 0,
      'unit': '100g',
      'weight': 100,
    },
    'salmon': {
      'calories': 206,
      'protein': 22,
      'carbs': 0,
      'fat': 13,
      'fiber': 0,
      'sugar': 0,
      'unit': '100g',
      'weight': 100,
    },
    'egg': {
      'calories': 72,
      'protein': 6.3,
      'carbs': 0.4,
      'fat': 5,
      'fiber': 0,
      'sugar': 0.4,
      'unit': 'large',
      'weight': 50,
    },
    'tofu': {
      'calories': 76,
      'protein': 8,
      'carbs': 2,
      'fat': 4.3,
      'fiber': 0.3,
      'sugar': 0.7,
      'unit': '100g',
      'weight': 100,
    },

    // Dairy
    'milk': {
      'calories': 42,
      'protein': 3.4,
      'carbs': 5,
      'fat': 1,
      'fiber': 0,
      'sugar': 5,
      'unit': '100ml',
      'weight': 100,
    },
    'cheese': {
      'calories': 402,
      'protein': 25,
      'carbs': 1.3,
      'fat': 33,
      'fiber': 0,
      'sugar': 0.5,
      'unit': '100g',
      'weight': 100,
    },
    'yogurt': {
      'calories': 59,
      'protein': 3.5,
      'carbs': 5,
      'fat': 3.3,
      'fiber': 0,
      'sugar': 5,
      'unit': '100g',
      'weight': 100,
    },

    // Grains
    'rice': {
      'calories': 130,
      'protein': 2.7,
      'carbs': 28,
      'fat': 0.3,
      'fiber': 0.4,
      'sugar': 0.1,
      'unit': '100g',
      'weight': 100,
    },
    'bread': {
      'calories': 265,
      'protein': 9,
      'carbs': 49,
      'fat': 3.2,
      'fiber': 2.7,
      'sugar': 5,
      'unit': '100g',
      'weight': 100,
    },
    'pasta': {
      'calories': 158,
      'protein': 5.8,
      'carbs': 31,
      'fat': 0.9,
      'fiber': 1.8,
      'sugar': 0.6,
      'unit': '100g',
      'weight': 100,
    },
    'oats': {
      'calories': 389,
      'protein': 16.9,
      'carbs': 66.3,
      'fat': 6.9,
      'fiber': 10.6,
      'sugar': 0,
      'unit': '100g',
      'weight': 100,
    },

    // Other common foods
    'avocado': {
      'calories': 160,
      'protein': 2,
      'carbs': 8.5,
      'fat': 14.7,
      'fiber': 6.7,
      'sugar': 0.7,
      'unit': '100g',
      'weight': 100,
    },
    'olive oil': {
      'calories': 884,
      'protein': 0,
      'carbs': 0,
      'fat': 100,
      'fiber': 0,
      'sugar': 0,
      'unit': '100ml',
      'weight': 100,
    },
    'chocolate': {
      'calories': 546,
      'protein': 4.9,
      'carbs': 61,
      'fat': 31,
      'fiber': 7,
      'sugar': 48,
      'unit': '100g',
      'weight': 100,
    },
    'honey': {
      'calories': 304,
      'protein': 0.3,
      'carbs': 82.4,
      'fat': 0,
      'fiber': 0.2,
      'sugar': 82.1,
      'unit': '100g',
      'weight': 100,
    },
    'butter': {
      'calories': 717,
      'protein': 0.9,
      'carbs': 0.1,
      'fat': 81,
      'fiber': 0,
      'sugar': 0.1,
      'unit': '100g',
      'weight': 100,
    },
  };

  /// Get nutrition data for a natural language query
  /// Now uses our local nutrition database
  Future<List<Nutrition>> getNutritionData(String query) async {
    // Split the query into individual items
    final List<String> items = query.toLowerCase().split(',');
    final List<Nutrition> results = [];

    for (final item in items) {
      final trimmedItem = item.trim();
      final Nutrition? nutrition = await _getNutritionForSingleItem(
        trimmedItem,
      );
      if (nutrition != null) {
        results.add(nutrition);
      }
    }

    return results;
  }

  /// Helper method to get nutrition for a single food item
  Future<Nutrition?> _getNutritionForSingleItem(String item) async {
    // Handle quantity extraction, e.g., "2 apples" or "100g of rice"
    double quantity = 1.0;
    String unit = '';
    String foodName = item;

    // Extract quantity patterns like "2 apples" or "100g rice"
    final RegExp quantityRegex = RegExp(
      r'^(\d+(?:\.\d+)?)\s*([a-zA-Z]*)\s+(.+)$',
    );
    final match = quantityRegex.firstMatch(item);

    if (match != null) {
      quantity = double.parse(match.group(1) ?? '1.0');
      unit = match.group(2) ?? '';
      foodName = match.group(3) ?? item;
    }

    // Search for the food in our database
    String? matchedFood;
    for (final food in nutritionDatabase.keys) {
      if (foodName.contains(food)) {
        matchedFood = food;
        break;
      }
    }

    if (matchedFood == null) {
      return null;
    }

    final foodData = nutritionDatabase[matchedFood]!;

    // Default to 100g if no unit specified
    double weightMultiplier = quantity;

    // Handle different units
    if (unit == 'g' || unit == 'grams') {
      weightMultiplier = quantity / 100.0; // Our data is per 100g
    } else if (unit == 'kg') {
      weightMultiplier = quantity * 10; // 1kg = 1000g
    } else if (unit == 'oz') {
      weightMultiplier = quantity * 28.35 / 100.0; // 1oz = 28.35g
    } else if (unit == 'lb' || unit == 'lbs') {
      weightMultiplier = quantity * 453.6 / 100.0; // 1lb = 453.6g
    } else if (unit == 'cup' || unit == 'cups') {
      // Rough cup conversion - varies by food type
      weightMultiplier = quantity * 2.5; // Assume 1 cup is ~250g
    } else if (unit == '') {
      // No unit specified, use the quantity as multiplier for the serving unit
      final servingWeight = foodData['weight'] as double;
      weightMultiplier = quantity * servingWeight / 100.0;
    }

    // Create and return nutrition object with adjusted quantities
    return Nutrition(
      foodName: matchedFood,
      calories: (foodData['calories'] as double) * weightMultiplier,
      totalFat: (foodData['fat'] as double) * weightMultiplier,
      protein: (foodData['protein'] as double) * weightMultiplier,
      carbs: (foodData['carbs'] as double) * weightMultiplier,
      fiber: (foodData['fiber'] as double) * weightMultiplier,
      sugar: (foodData['sugar'] as double) * weightMultiplier,
      servingUnit: foodData['unit'] as String,
      servingWeight: (foodData['weight'] as double) * quantity,
      imageUrl: 'https://www.themealdb.com/images/ingredients/$matchedFood.png',
    );
  }

  /// Search food items by name using our local database
  Future<List<Nutrition>> searchFoodItems(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final List<Nutrition> results = [];
    final lowercaseQuery = query.toLowerCase();

    for (final food in nutritionDatabase.keys) {
      if (food.contains(lowercaseQuery)) {
        final foodData = nutritionDatabase[food]!;
        results.add(
          Nutrition(
            foodName: food,
            calories: foodData['calories'] as double,
            totalFat: foodData['fat'] as double,
            protein: foodData['protein'] as double,
            carbs: foodData['carbs'] as double,
            fiber: foodData['fiber'] as double,
            sugar: foodData['sugar'] as double,
            servingUnit: foodData['unit'] as String,
            servingWeight: foodData['weight'] as double,
            imageUrl: 'https://www.themealdb.com/images/ingredients/$food.png',
          ),
        );
      }
    }

    return results;
  }

  /// Calculate calories for a meal or recipe
  /// Takes a list of ingredients as natural language strings
  /// and returns the total calories
  Future<double> calculateCalories(List<String> ingredients) async {
    if (ingredients.isEmpty) {
      return 0.0;
    }

    // Join all ingredients into a single query
    String query = ingredients.join(', ');

    try {
      List<Nutrition> nutritionData = await getNutritionData(query);

      // Sum up all calories
      double totalCalories = 0;
      for (var item in nutritionData) {
        totalCalories += item.calories;
      }

      return totalCalories;
    } catch (e) {
      throw Exception('Failed to calculate calories: $e');
    }
  }
}
