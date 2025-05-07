import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

/// Service class that handles API requests to TheMealDB API
/// TheMealDB is a database of recipes from around the world
/// API Documentation: https://www.themealdb.com/api.php
class RecipeService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Search recipes by name
  /// API endpoint: /search.php?s={query}
  Future<List<Recipe>> searchRecipes(String query) async {
    // Validate query
    if (query.trim().isEmpty) {
      return [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?s=${Uri.encodeComponent(query)}')
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['meals'] == null) {
          return [];
        }
        
        return (data['meals'] as List)
            .map((meal) => Recipe.fromJson(meal))
            .toList();
      } else {
        throw Exception('Failed to search recipes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search recipes: $e');
    }
  }

  /// Get recipes by category
  /// API endpoint: /filter.php?c={category}
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    // Validate category
    if (category.trim().isEmpty) {
      return [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=${Uri.encodeComponent(category)}')
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['meals'] == null) {
          return [];
        }
        
        // The filter endpoint only returns basic information
        // We need to fetch full details for each recipe
        List<Recipe> recipes = [];
        
        // Limit to 5 recipes to avoid too many API calls
        final items = (data['meals'] as List).take(5).toList();
        
        for (var meal in items) {
          try {
            // Fetch full recipe details by ID
            Recipe recipe = await getRecipeById(meal['idMeal']);
            recipes.add(recipe);
          } catch (e) {
            // Skip this recipe if we can't load its details
            continue;
          }
        }
        
        return recipes;
      } else {
        throw Exception('Failed to get recipes by category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get recipes by category: $e');
    }
  }

  /// Get recipes by area (country/region)
  /// API endpoint: /filter.php?a={area}
  Future<List<Recipe>> getRecipesByArea(String area) async {
    // Validate area
    if (area.trim().isEmpty) {
      return [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?a=${Uri.encodeComponent(area)}')
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['meals'] == null) {
          return [];
        }
        
        // The filter endpoint only returns basic information
        // We need to fetch full details for each recipe
        List<Recipe> recipes = [];
        
        // Limit to 5 recipes to avoid too many API calls
        final items = (data['meals'] as List).take(5).toList();
        
        for (var meal in items) {
          try {
            // Fetch full recipe details by ID
            Recipe recipe = await getRecipeById(meal['idMeal']);
            recipes.add(recipe);
          } catch (e) {
            // Skip this recipe if we can't load its details
            continue;
          }
        }
        
        return recipes;
      } else {
        throw Exception('Failed to get recipes by area: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get recipes by area: $e');
    }
  }

  /// Get recipe details by ID
  /// API endpoint: /lookup.php?i={id}
  Future<Recipe> getRecipeById(String id) async {
    // Validate ID
    if (id.trim().isEmpty) {
      throw Exception('Recipe ID cannot be empty');
    }
    
    try {
      final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['meals'] == null || (data['meals'] as List).isEmpty) {
          throw Exception('Recipe not found');
        }
        
        return Recipe.fromJson(data['meals'][0]);
      } else {
        throw Exception('Failed to get recipe details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get recipe details: $e');
    }
  }

  /// Get list of all categories
  /// API endpoint: /list.php?c=list
  Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list.php?c=list'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['meals'] == null) {
          return [];
        }
        
        return (data['meals'] as List)
            .map((category) => category['strCategory'] as String)
            .toList();
      } else {
        throw Exception('Failed to get categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  /// Get list of all areas (countries/regions)
  /// API endpoint: /list.php?a=list
  Future<List<String>> getAreas() async {
    try {
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
        throw Exception('Failed to get areas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get areas: $e');
    }
  }
}
