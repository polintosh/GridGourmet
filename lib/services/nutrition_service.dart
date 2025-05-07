import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nutrition.dart';

/// Service class that handles API requests to the Nutritionix API
/// Nutritionix is a nutrition database API that provides detailed
/// nutritional information for various foods
/// API Documentation: https://developer.nutritionix.com/docs/v2
class NutritionService {
  final String baseUrl = 'https://trackapi.nutritionix.com/v2';
  
  // API credentials - Replace with your actual API credentials
  // for production use, and ideally these should be stored securely
  final String appId = 'YOUR_APP_ID';
  final String appKey = 'YOUR_APP_KEY';

  /// Get nutrition data for a natural language query
  /// Uses the Nutritionix Natural Language Processing API
  /// API endpoint: /natural/nutrients
  /// Documentation: https://developer.nutritionix.com/docs/v2/natural-nutrient
  Future<List<Nutrition>> getNutritionData(String query) async {
    // Validate query
    if (query.trim().isEmpty) {
      return [];
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/natural/nutrients'),
        headers: {
          'Content-Type': 'application/json',
          'x-app-id': appId,
          'x-app-key': appKey,
          'x-remote-user-id': '0', // 0 for development
        },
        body: json.encode({
          'query': query,
          'timezone': 'US/Eastern', // Adjust timezone as needed
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['foods'] == null) {
          return [];
        }
        
        return (data['foods'] as List)
            .map((food) => Nutrition.fromJson(food))
            .toList();
      } else {
        throw Exception('Failed to get nutrition data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get nutrition data: $e');
    }
  }

  /// Search food items by name using the Nutritionix API
  /// API endpoint: /search/instant
  /// Documentation: https://developer.nutritionix.com/docs/v2/search
  Future<List<Nutrition>> searchFoodItems(String query) async {
    // Validate query
    if (query.trim().isEmpty) {
      return [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/instant?query=${Uri.encodeComponent(query)}&detailed=true'),
        headers: {
          'x-app-id': appId,
          'x-app-key': appKey,
          'x-remote-user-id': '0', // 0 for development
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['common'] == null) {
          return [];
        }
        
        // Convert common food items to Nutrition objects
        final List<Nutrition> nutritionList = [];
        
        // Process only the first 5 items to avoid excessive API calls
        final itemsToProcess = (data['common'] as List).take(5).toList();
        
        for (var food in itemsToProcess) {
          try {
            // For each common food, get detailed nutrition via natural language
            final detailedResponse = await http.post(
              Uri.parse('$baseUrl/natural/nutrients'),
              headers: {
                'Content-Type': 'application/json',
                'x-app-id': appId,
                'x-app-key': appKey,
                'x-remote-user-id': '0',
              },
              body: json.encode({
                'query': food['food_name'],
              }),
            );
            
            if (detailedResponse.statusCode == 200) {
              final detailedData = json.decode(detailedResponse.body);
              if (detailedData['foods'] != null && (detailedData['foods'] as List).isNotEmpty) {
                nutritionList.add(Nutrition.fromJson(detailedData['foods'][0]));
              }
            }
          } catch (e) {
            // Skip this item if there's an error
            continue;
          }
        }
        
        return nutritionList;
      } else {
        throw Exception('Failed to search food items: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to search food items: $e');
    }
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
