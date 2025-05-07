import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nutrition.dart';

class NutritionService {
  final String baseUrl = 'https://trackapi.nutritionix.com/v2';
  
  // These would need to be replaced with your actual API credentials
  final String appId = 'YOUR_APP_ID';
  final String appKey = 'YOUR_APP_KEY';

  // Get nutrition data for a natural language query
  Future<List<Nutrition>> getNutritionData(String query) async {
    final response = await http.post(
      Uri.parse('$baseUrl/natural/nutrients'),
      headers: {
        'Content-Type': 'application/json',
        'x-app-id': appId,
        'x-app-key': appKey,
      },
      body: json.encode({
        'query': query,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['foods'] == null) {
        return [];
      }
      
      return _parseNutritionData(data['foods']);
    } else {
      throw Exception('Failed to get nutrition data: ${response.statusCode}');
    }
  }

  // Search food items by name
  Future<List<Nutrition>> searchFoodItems(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/instant?query=$query'),
      headers: {
        'x-app-id': appId,
        'x-app-key': appKey,
      },
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['common'] == null) {
        return [];
      }
      
      // For each common food item, get detailed nutrition info
      List<Nutrition> nutritionList = [];
      for (var food in data['common']) {
        try {
          List<Nutrition> detailedNutrition = await getNutritionData(food['food_name']);
          if (detailedNutrition.isNotEmpty) {
            nutritionList.add(detailedNutrition[0]);
          }
        } catch (e) {
          // Skip this item if there's an error
          continue;
        }
      }
      
      return nutritionList;
    } else {
      throw Exception('Failed to search food items');
    }
  }

  // Calculate calories for a meal or recipe
  Future<double> calculateCalories(List<String> ingredients) async {
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

  // Helper method to parse nutrition data from API response
  List<Nutrition> _parseNutritionData(List<dynamic> foodsData) {
    return foodsData.map((food) {
      return Nutrition(
        foodName: food['food_name'] ?? '',
        calories: food['nf_calories']?.toDouble() ?? 0.0,
        totalFat: food['nf_total_fat']?.toDouble() ?? 0.0,
        protein: food['nf_protein']?.toDouble() ?? 0.0,
        carbs: food['nf_total_carbohydrate']?.toDouble() ?? 0.0,
        fiber: food['nf_dietary_fiber']?.toDouble() ?? 0.0,
        sugar: food['nf_sugars']?.toDouble() ?? 0.0,
        servingUnit: food['serving_unit'] ?? '',
        servingWeight: food['serving_weight_grams']?.toDouble() ?? 0.0,
        imageUrl: food['photo']['thumb'] ?? '',
      );
    }).toList();
  }
}
