import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Search recipes by name
  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null) {
        return [];
      }
      
      return _parseRecipes(data['meals']);
    } else {
      throw Exception('Failed to search recipes');
    }
  }

  // Get recipes by category
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null) {
        return [];
      }
      
      List<Recipe> recipes = [];
      for (var meal in data['meals']) {
        // The filter endpoint doesn't return full details, so we need to fetch them
        recipes.add(await getRecipeById(meal['idMeal']));
      }
      
      return recipes;
    } else {
      throw Exception('Failed to get recipes by category');
    }
  }

  // Get recipes by area (country/region)
  Future<List<Recipe>> getRecipesByArea(String area) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?a=$area'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null) {
        return [];
      }
      
      List<Recipe> recipes = [];
      for (var meal in data['meals']) {
        // The filter endpoint doesn't return full details, so we need to fetch them
        recipes.add(await getRecipeById(meal['idMeal']));
      }
      
      return recipes;
    } else {
      throw Exception('Failed to get recipes by area');
    }
  }

  // Get recipe details by ID
  Future<Recipe> getRecipeById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null || data['meals'].isEmpty) {
        throw Exception('Recipe not found');
      }
      
      return _parseRecipes([data['meals'][0]])[0];
    } else {
      throw Exception('Failed to get recipe details');
    }
  }

  // Get list of all categories
  Future<List<String>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/list.php?c=list'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null) {
        return [];
      }
      
      return List<String>.from(data['meals'].map((category) => category['strCategory']));
    } else {
      throw Exception('Failed to get categories');
    }
  }

  // Get list of all areas (countries/regions)
  Future<List<String>> getAreas() async {
    final response = await http.get(Uri.parse('$baseUrl/list.php?a=list'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['meals'] == null) {
        return [];
      }
      
      return List<String>.from(data['meals'].map((area) => area['strArea']));
    } else {
      throw Exception('Failed to get areas');
    }
  }

  // Helper method to parse recipes from API response
  List<Recipe> _parseRecipes(List<dynamic> mealsData) {
    return mealsData.map((meal) {
      // Extract ingredients and measures
      List<String> ingredients = [];
      List<String> measures = [];
      
      for (int i = 1; i <= 20; i++) {
        String ingredient = meal['strIngredient$i'] ?? '';
        String measure = meal['strMeasure$i'] ?? '';
        
        if (ingredient.trim().isNotEmpty) {
          ingredients.add(ingredient);
          measures.add(measure.trim().isNotEmpty ? measure : '');
        }
      }
      
      return Recipe(
        id: meal['idMeal'] ?? '',
        name: meal['strMeal'] ?? '',
        category: meal['strCategory'] ?? '',
        area: meal['strArea'] ?? '',
        instructions: meal['strInstructions'] ?? '',
        thumbnailUrl: meal['strMealThumb'] ?? '',
        ingredients: ingredients,
        measures: measures,
      );
    }).toList();
  }
}
