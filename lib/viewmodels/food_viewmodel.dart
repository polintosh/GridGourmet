import 'package:flutter/foundation.dart';
import '../models/food.dart';
import '../services/food_service.dart';

/// ViewModel class that manages food data and operations
/// Follows MVVM pattern by separating business logic from the View
class FoodViewModel extends ChangeNotifier {
  final FoodService _foodService = FoodService();
  
  // State variables
  List<Food> _foods = [];
  final Map<String, bool> _shoppingListItems = {};
  String _searchText = '';
  int _selectedTabIndex = 0;
  bool _isLoading = false;
  String? _error;
  List<String> _categories = [];
  List<String> _countries = [];
  
  // Getters
  List<Food> get foods => _foods;
  Map<String, bool> get shoppingListItems => _shoppingListItems;
  String get searchText => _searchText;
  int get selectedTabIndex => _selectedTabIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get categories => _categories;
  List<String> get countries => _countries;
  
  // Computed property - filtered foods based on search text
  List<Food> get filteredFoods {
    if (_searchText.isEmpty) {
      return _foods;
    }
    return _foods.where((food) {
      return food.name.toLowerCase().contains(_searchText.toLowerCase()) ||
             food.country.toLowerCase().contains(_searchText.toLowerCase()) ||
             food.category.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }
  
  // Computed property - foods in shopping list
  List<Food> get shoppingListFoods {
    if (_selectedTabIndex == 1) {
      return filteredFoods.where((food) => _shoppingListItems[food.id] == true).toList();
    }
    return filteredFoods;
  }
  
  // Initialize ViewModel with mock data
  FoodViewModel() {
    loadMockFoods();
    // Load categories and countries in the background
    _loadCategories();
    _loadCountries();
  }
  
  /// Load mock food data
  void loadMockFoods() {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _foods = Food.getMockFoods();
      // Initialize shopping list with mock data
      for (var food in _foods) {
        _shoppingListItems[food.id] = food.isInShoppingList;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load foods: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load a random meal
  Future<void> loadRandomMeal() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final food = await _foodService.getRandomFood();
      if (food != null) {
        _foods = [food];
      } else {
        _foods = [];
        _error = 'No random meal found';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load random meal: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load all available meal categories
  Future<void> _loadCategories() async {
    try {
      _categories = await _foodService.getAllCategories();
      notifyListeners();
    } catch (e) {
      // Just log the error but don't show it to the user since this is a background operation
      print('Failed to load categories: ${e.toString()}');
    }
  }
  
  /// Load all available countries/areas
  Future<void> _loadCountries() async {
    try {
      _countries = await _foodService.getAllCountries();
      notifyListeners();
    } catch (e) {
      // Just log the error but don't show it to the user since this is a background operation
      print('Failed to load countries: ${e.toString()}');
    }
  }
  
  /// Search for meals using the API
  Future<void> searchFoods(String query) async {
    if (query.isEmpty) {
      loadMockFoods();
      return;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final results = await _foodService.searchFoodByName(query);
      _foods = results;
      // Update shopping list items for new foods
      for (var food in _foods) {
        if (!_shoppingListItems.containsKey(food.id)) {
          _shoppingListItems[food.id] = false;
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to search meals: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load meals by category
  Future<void> loadFoodsByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final results = await _foodService.getFoodsByCategory(category);
      _foods = results;
      // Update shopping list items for new foods
      for (var food in _foods) {
        if (!_shoppingListItems.containsKey(food.id)) {
          _shoppingListItems[food.id] = false;
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load meals by category: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load meals by country
  Future<void> loadFoodsByCountry(String country) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final results = await _foodService.getFoodsByCountry(country);
      _foods = results;
      // Update shopping list items for new foods
      for (var food in _foods) {
        if (!_shoppingListItems.containsKey(food.id)) {
          _shoppingListItems[food.id] = false;
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load meals by country: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Set search text for filtering foods
  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }
  
  /// Change selected tab index
  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }
  
  /// Toggle food item in shopping list
  void toggleShoppingListItem(String foodId) {
    _shoppingListItems[foodId] = !(_shoppingListItems[foodId] ?? false);
    notifyListeners();
  }
  
  /// Add a food item to the shopping list
  void addToShoppingList(String foodId) {
    _shoppingListItems[foodId] = true;
    notifyListeners();
  }
  
  /// Remove a food item from the shopping list
  void removeFromShoppingList(String foodId) {
    _shoppingListItems[foodId] = false;
    notifyListeners();
  }
}
