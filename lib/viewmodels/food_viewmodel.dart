import 'package:flutter/foundation.dart';
import '../models/food.dart';
import '../services/food_service.dart';
import '../utils/logger.dart';

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
  final List<String> _countries = [];

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
      return filteredFoods
          .where((food) => _shoppingListItems[food.id] == true)
          .toList();
    }
    return filteredFoods;
  }

  // Initialize ViewModel with basic foods
  FoodViewModel() {
    loadBasicFoods();
    // Load categories
    _loadCategories();
  }

  /// Load basic food ingredients instead of recipes
  Future<void> loadBasicFoods() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _foods = await _foodService.getAllBasicFoods();
      // Initialize shopping list
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

  /// Load a specific food category (fruits, vegetables, etc)
  Future<void> loadFoodCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _foods = await _foodService.getBasicFoodsByCategory(category);
      // Update shopping list items for new foods
      for (var food in _foods) {
        if (!_shoppingListItems.containsKey(food.id)) {
          _shoppingListItems[food.id] = false;
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load food category: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load mock food data if needed for testing
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

  /// Search for basic food items
  Future<void> searchFoods(String query) async {
    if (query.isEmpty) {
      loadBasicFoods();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Use the basic food search instead of recipe search
      final results = await _foodService.searchBasicFoodByName(query);
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
      _error = 'Failed to search foods: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all available food categories
  Future<void> _loadCategories() async {
    try {
      _categories = await _foodService.getAllCategories();
      notifyListeners();
    } catch (e) {
      // Just log the error but don't show it to the user since this is a background operation
      AppLogger.instance.warning('Failed to load categories: ${e.toString()}');
    }
  }

  /// Set search text for filtering foods
  void setSearchText(String text) {
    _searchText = text;
    if (text.isNotEmpty) {
      searchFoods(text);
    }
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
