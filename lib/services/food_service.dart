import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food.dart';

/// Service class that handles API requests to TheMealDB API and retrieves individual foods
/// This updated version focuses on basic foods, ingredients, and nutrition
class FoodService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Get list of all ingredients
  /// API endpoint: /list.php?i=list
  /// Documentation: https://www.themealdb.com/api.php
  Future<List<Food>> getAllBasicFoods() async {
    final response = await http.get(Uri.parse('$baseUrl/list.php?i=list'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] == null) {
        return [];
      }

      final List<Food> foods = [];

      // Convert the ingredient data to Food objects
      for (var ingredient in data['meals']) {
        final id = ingredient['idIngredient'] ?? '';
        final name = ingredient['strIngredient'] ?? '';

        // Create a basic food item for this ingredient
        final food = Food(
          id: id,
          name: name,
          imageUrl: 'https://www.themealdb.com/images/ingredients/$name.png',
          country: 'Various', // Most ingredients don't have a specific country
          ingredients: name, // The ingredient is itself
          category: 'Ingredient',
        );

        foods.add(food);
      }

      return foods;
    } else {
      throw Exception('Failed to get ingredients: ${response.statusCode}');
    }
  }

  /// Search for basic food items by name
  /// This uses the ingredients list and filters by name
  Future<List<Food>> searchBasicFoodByName(String query) async {
    if (query.isEmpty) {
      return [];
    }

    // First get all ingredients
    final allFoods = await getAllBasicFoods();

    // Then filter by name
    return allFoods
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Get food details by ingredient name
  /// This gets a single food item by its name
  Future<Food?> getBasicFoodByName(String name) async {
    if (name.isEmpty) {
      return null;
    }

    // First search for the food
    final foods = await searchBasicFoodByName(name);

    // Return the first match if found
    if (foods.isNotEmpty) {
      return foods.first;
    }

    return null;
  }

  /// Get foods by category (fruits, vegetables, proteins, etc)
  /// We're using our own categorization since TheMealDB doesn't categorize ingredients
  Future<List<Food>> getBasicFoodsByCategory(String category) async {
    // Get all foods first
    final allFoods = await getAllBasicFoods();

    // Basic food categories
    final Map<String, List<String>> foodCategories = {
      'Fruits': [
        'apple',
        'banana',
        'orange',
        'strawberry',
        'blueberry',
        'raspberry',
        'grape',
        'pear',
        'peach',
        'plum',
        'cherry',
        'watermelon',
        'melon',
        'kiwi',
        'pineapple',
        'mango',
        'apricot',
        'fig',
        'guava',
        'papaya',
      ],

      'Vegetables': [
        'carrot',
        'broccoli',
        'spinach',
        'lettuce',
        'potato',
        'tomato',
        'onion',
        'garlic',
        'cucumber',
        'zucchini',
        'eggplant',
        'pepper',
        'cabbage',
        'cauliflower',
        'asparagus',
        'corn',
        'pea',
        'green bean',
        'radish',
        'turnip',
        'kale',
        'celery',
      ],

      'Proteins': [
        'chicken',
        'beef',
        'pork',
        'lamb',
        'fish',
        'shrimp',
        'egg',
        'tofu',
        'tempeh',
        'beans',
        'lentils',
        'chickpeas',
        'nuts',
        'seeds',
        'turkey',
        'duck',
        'salmon',
        'tuna',
      ],

      'Dairy': [
        'milk',
        'cheese',
        'yogurt',
        'butter',
        'cream',
        'sour cream',
        'ice cream',
        'cottage cheese',
        'mozzarella',
        'cheddar',
      ],

      'Grains': [
        'rice',
        'pasta',
        'bread',
        'cereal',
        'oats',
        'quinoa',
        'barley',
        'bulgur',
        'couscous',
        'flour',
        'tortilla',
        'noodle',
      ],
    };

    // If we don't have this category, return empty list
    if (!foodCategories.containsKey(category)) {
      return [];
    }

    // Filter foods that match any term in the category
    final categoryTerms = foodCategories[category]!;

    return allFoods.where((food) {
      final foodName = food.name.toLowerCase();
      // Check if the food name contains any of the category terms
      return categoryTerms.any((term) => foodName.contains(term));
    }).toList();
  }

  /// Original TheMealDB API methods still available below
  /// These can be used when you need full recipe information

  /// Search for meals by name
  /// API endpoint: /search.php?s={name}
  /// Documentation: https://www.themealdb.com/api.php
  Future<List<Food>> searchFoodByName(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));

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
      Uri.parse('$baseUrl/filter.php?c=$category'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] == null) {
        return [];
      }

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
      throw Exception(
        'Failed to get meals by category: ${response.statusCode}',
      );
    }
  }

  /// Get meals by area/country
  /// API endpoint: /filter.php?a={area}
  /// Documentation: https://www.themealdb.com/api.php
  Future<List<Food>> getFoodsByCountry(String country) async {
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?a=$country'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] == null) {
        return [];
      }

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
    // Add our custom basic food categories
    return ['Fruits', 'Vegetables', 'Proteins', 'Dairy', 'Grains'];
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
