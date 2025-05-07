import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food.dart';

/// Service class that handles API requests to TheMealDB API
/// TheMealDB is an open database of recipes with detailed information
/// API Documentation: https://www.themealdb.com/api.php
class FoodService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Search for meals by name
  /// API endpoint: /search.php?s={name}
  /// Documentation: https://www.themealdb.com/api.php
  Future<List<Food>> searchFoodByName(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?s=$query')
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null) {
        return [];
      }
      
      return (data['meals'] as List)
          .map((mealData) => Food.fromTheMealDBJson(mealData))
          .toList();
    } else {
      throw Exception('Failed to search meals: ${response.statusCode}');
    }
  }

  /// Get meal details by ID
  /// API endpoint: /lookup.php?i={id}
  /// Documentation: https://www.themealdb.com/api.php
  Future<Food?> getFoodById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null || (data['meals'] as List).isEmpty) {
        return null;
      }
      
      return Food.fromTheMealDBJson(data['meals'][0]);
    } else {
      throw Exception('Failed to get meal by ID: ${response.statusCode}');
    }
  }

  /// Get random meal
  /// API endpoint: /random.php
  /// Documentation: https://www.themealdb.com/api.php
  Future<Food?> getRandomFood() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null || (data['meals'] as List).isEmpty) {
        return null;
      }
      
      return Food.fromTheMealDBJson(data['meals'][0]);
    } else {
      throw Exception('Failed to get random meal: ${response.statusCode}');
    }
  }

  /// Get meals by category
  /// API endpoint: /filter.php?c={category}
  /// Documentation: https://www.themealdb.com/api.php
  Future<List<Food>> getFoodsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?c=$category')
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null) {
        return [];
      }
      
      // The filter endpoint returns limited meal data
      // We need to fetch full details for each meal
      final meals = <Food>[];
      
      for (var mealData in data['meals']) {
        final id = mealData['idMeal'];
        
        // Create a basic Food object with limited data
        final food = Food(
          id: id,
          name: mealData['strMeal'] ?? '',
          imageUrl: mealData['strMealThumb'] ?? '',
          country: '',
          ingredients: '',
          category: category,
        );
        
        meals.add(food);
      }
      
      return meals;
    } else {
      throw Exception('Failed to get meals by category: ${response.statusCode}');
    }
  }

  /// Get meals by area/country
  /// API endpoint: /filter.php?a={area}
  /// Documentation: https://www.themealdb.com/api.php
  Future<List<Food>> getFoodsByCountry(String country) async {
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?a=$country')
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null) {
        return [];
      }
      
      // The filter endpoint returns limited meal data
      // We need to fetch full details for each meal
      final meals = <Food>[];
      
      for (var mealData in data['meals']) {
        final id = mealData['idMeal'];
        
        // Create a basic Food object with limited data
        final food = Food(
          id: id,
          name: mealData['strMeal'] ?? '',
          imageUrl: mealData['strMealThumb'] ?? '',
          country: country,
          ingredients: '',
          category: '',
        );
        
        meals.add(food);
      }
      
      return meals;
    } else {
      throw Exception('Failed to get meals by country: ${response.statusCode}');
    }
  }

  /// Get list of all categories
  /// API endpoint: /categories.php
  /// Documentation: https://www.themealdb.com/api.php
  Future<List<String>> getAllCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['categories'] == null) {
        return [];
      }
      
      return (data['categories'] as List)
          .map((category) => category['strCategory'] as String)
          .toList();
    } else {
      throw Exception('Failed to get categories: ${response.statusCode}');
    }
  }

  /// Get list of all areas/countries
  /// API endpoint: /list.php?a=list
  /// Documentation: https://www.themealdb.com/api.php
  Future<List<String>> getAllCountries() async {
    final response = await http.get(Uri.parse('$baseUrl/list.php?a=list'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null) {
        return [];
      }
      
      return (data['meals'] as List)
          .map((area) => area['strArea'] as String)
          .toList();
    } else {
      throw Exception('Failed to get countries: ${response.statusCode}');
    }
  }
}
