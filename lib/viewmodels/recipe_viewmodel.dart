import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../utils/logger.dart';

/// ViewModel for handling recipe data and operations
/// Follows MVVM pattern by separating business logic from the View
class RecipeViewModel extends ChangeNotifier {
  final RecipeService _recipeService = RecipeService();
  
  // State variables
  List<Recipe> _recipes = [];
  List<Recipe> _featuredRecipes = [];
  Map<String, List<Recipe>> _categorizedRecipes = {};
  List<String> _categories = [];
  List<String> _areas = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Recipe> get recipes => _recipes;
  List<Recipe> get featuredRecipes => _featuredRecipes;
  Map<String, List<Recipe>> get categorizedRecipes => _categorizedRecipes;
  List<String> get categories => _categories;
  List<String> get areas => _areas;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Initialize ViewModel with mock data
  RecipeViewModel() {
    loadMockRecipes();
    // Load categories and areas in the background
    _loadCategories();
    _loadAreas();
  }
  
  /// Load mock recipe data
  void loadMockRecipes() {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _recipes = Recipe.getMockRecipes();
      
      // Set the first recipes as featured
      _featuredRecipes = _recipes.take(3).toList();
      
      // Categorize recipes
      _categorizeRecipes();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load recipes: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Search for recipes by name
  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) {
      loadMockRecipes();
      return;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _recipes = await _recipeService.searchRecipes(query);
      
      // Set top results as featured
      _featuredRecipes = _recipes.take(min(3, _recipes.length)).toList();
      
      // Categorize recipes
      _categorizeRecipes();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to search recipes: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load recipes by category
  Future<void> loadRecipesByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _recipes = await _recipeService.getRecipesByCategory(category);
      
      // Set top results as featured
      _featuredRecipes = _recipes.take(min(3, _recipes.length)).toList();
      
      // Categorize recipes
      _categorizeRecipes();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load recipes by category: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load recipes by area/country
  Future<void> loadRecipesByArea(String area) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _recipes = await _recipeService.getRecipesByArea(area);
      
      // Set top results as featured
      _featuredRecipes = _recipes.take(min(3, _recipes.length)).toList();
      
      // Categorize recipes
      _categorizeRecipes();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load recipes by area: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Helper method to load all available categories
  Future<void> _loadCategories() async {
    try {
      _categories = await _recipeService.getCategories();
      notifyListeners();
    } catch (e) {
      AppLogger.instance.warning('Failed to load categories: ${e.toString()}');
    }
  }
  
  /// Helper method to load all available areas/countries
  Future<void> _loadAreas() async {
    try {
      _areas = await _recipeService.getAreas();
      notifyListeners();
    } catch (e) {
      AppLogger.instance.warning('Failed to load areas: ${e.toString()}');
    }
  }
  
  /// Helper method to categorize recipes
  void _categorizeRecipes() {
    _categorizedRecipes = {};
    
    for (var recipe in _recipes) {
      if (!_categorizedRecipes.containsKey(recipe.category)) {
        _categorizedRecipes[recipe.category] = [];
      }
      _categorizedRecipes[recipe.category]!.add(recipe);
    }
  }
  
  /// Toggle favorite status for a recipe
  void toggleFavorite(String recipeId) {
    // Find recipe in all collections and toggle its favorite status
    for (int i = 0; i < _recipes.length; i++) {
      if (_recipes[i].id == recipeId) {
        final updatedRecipe = _recipes[i].copyWith(
          isFavorite: !_recipes[i].isFavorite
        );
        _recipes[i] = updatedRecipe;
      }
    }
    
    for (int i = 0; i < _featuredRecipes.length; i++) {
      if (_featuredRecipes[i].id == recipeId) {
        final updatedRecipe = _featuredRecipes[i].copyWith(
          isFavorite: !_featuredRecipes[i].isFavorite
        );
        _featuredRecipes[i] = updatedRecipe;
      }
    }
    
    // Update categorized recipes
    _categorizeRecipes();
    
    notifyListeners();
  }
}

// Helper function to get minimum of two values
int min(int a, int b) {
  return a < b ? a : b;
}
