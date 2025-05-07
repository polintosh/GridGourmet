import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food.dart';

class FoodService {
  final String baseUrl = 'https://world.openfoodfacts.org';

  // Search food by name
  Future<List<Food>> searchFoodByName(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=1')
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['products'] == null) {
        return [];
      }
      
      return _parseFoods(data['products']);
    } else {
      throw Exception('Failed to search foods');
    }
  }

  // Get food by barcode
  Future<Food?> getFoodByBarcode(String barcode) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v0/product/$barcode.json'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['status'] != 1 || data['product'] == null) {
        return null;
      }
      
      return _parseFood(data['product']);
    } else {
      throw Exception('Failed to get food by barcode');
    }
  }

  // Get foods by country
  Future<List<Food>> getFoodsByCountry(String country) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cgi/search.pl?tagtype_0=countries&tag_contains_0=contains&tag_0=$country&json=1')
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['products'] == null) {
        return [];
      }
      
      return _parseFoods(data['products']);
    } else {
      throw Exception('Failed to get foods by country');
    }
  }

  // Get foods by nutrition grade
  Future<List<Food>> getFoodsByNutritionGrade(String grade) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cgi/search.pl?tagtype_0=nutrition_grades&tag_contains_0=contains&tag_0=$grade&json=1')
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['products'] == null) {
        return [];
      }
      
      return _parseFoods(data['products']);
    } else {
      throw Exception('Failed to get foods by nutrition grade');
    }
  }

  // Helper method to parse a single food from API response
  Food _parseFood(Map<String, dynamic> productData) {
    String id = productData['code'] ?? '';
    String name = productData['product_name'] ?? '';
    String imageUrl = productData['image_url'] ?? '';
    
    // Extract country information
    String country = '';
    if (productData['countries_tags'] != null && productData['countries_tags'].isNotEmpty) {
      // Remove 'en:' prefix from country tag
      String countryTag = productData['countries_tags'][0];
      country = countryTag.startsWith('en:') ? countryTag.substring(3) : countryTag;
      // Capitalize first letter
      country = country.split('_').map((word) => 
        word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ');
    }
    
    String ingredients = productData['ingredients_text'] ?? '';
    String nutritionGrade = (productData['nutrition_grades'] ?? '').toLowerCase();
    
    return Food(
      id: id,
      name: name,
      imageUrl: imageUrl,
      country: country,
      ingredients: ingredients,
      nutritionGrade: nutritionGrade,
    );
  }

  // Helper method to parse multiple foods from API response
  List<Food> _parseFoods(List<dynamic> productsData) {
    return productsData.map((product) => _parseFood(product)).toList();
  }
}
