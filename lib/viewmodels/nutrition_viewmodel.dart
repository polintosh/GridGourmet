import 'package:flutter/foundation.dart';
import '../models/nutrition.dart';
import '../services/nutrition_service.dart';

/// ViewModel for handling nutrition data and operations
/// Follows MVVM pattern by separating business logic from the View
class NutritionViewModel extends ChangeNotifier {
  final NutritionService _nutritionService = NutritionService();

  // State variables
  List<Nutrition> _selectedItems = [];
  List<Nutrition> _suggestions = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Nutrition> get selectedItems => _selectedItems;
  List<Nutrition> get suggestions => _suggestions;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Clear all state when ViewModel is initialized
  NutritionViewModel() {
    _selectedItems = [];
    _suggestions = [];
    _searchQuery = '';
    _isLoading = false;
    _error = null;
  }

  /// Set search query and update suggestions if needed
  void setSearchQuery(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }

    // If query is not empty, search for suggestions
    searchNutritionData(query);
  }

  /// Search for nutrition data using the API
  Future<void> searchNutritionData(String query) async {
    if (query.isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Use mock data in development or when API keys are not set
      if (_nutritionService.appId == 'YOUR_APP_ID' ||
          _nutritionService.appKey == 'YOUR_APP_KEY') {
        // Filter mock data based on query
        final allNutrition = Nutrition.getMockNutritionData();
        _suggestions =
            allNutrition
                .where(
                  (item) =>
                      item.foodName.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      } else {
        // Use real API data
        _suggestions = await _nutritionService.searchFoodItems(query);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to search nutrition data: ${e.toString()}';
      _isLoading = false;
      _suggestions = [];
      notifyListeners();
    }
  }

  /// Add a nutrition item to selected items
  void addNutritionItem(Nutrition item) {
    _selectedItems.add(item);
    _suggestions = []; // Clear suggestions after adding an item
    _searchQuery = ''; // Clear search query
    notifyListeners();
  }

  /// Remove a nutrition item from selected items by index
  void removeNutritionItem(int index) {
    if (index >= 0 && index < _selectedItems.length) {
      _selectedItems.removeAt(index);
      notifyListeners();
    }
  }

  /// Clear all selected items
  void clearSelectedItems() {
    _selectedItems = [];
    notifyListeners();
  }

  /// Calculate total calories and macros
  Map<String, double> calculateTotals() {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var item in _selectedItems) {
      totalCalories += item.calories;
      totalProtein += item.protein;
      totalCarbs += item.carbs;
      totalFat += item.totalFat;
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
    };
  }
}
