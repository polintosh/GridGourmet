import 'package:flutter/cupertino.dart';
import '../../models/nutrition.dart';
import 'widgets/nutrition_summary.dart';
import 'widgets/empty_nutrition_state.dart';
import 'widgets/suggestion_item.dart';
import 'widgets/selected_food_item.dart';

class NutritionInputScreen extends StatefulWidget {
  const NutritionInputScreen({super.key});

  @override
  State<NutritionInputScreen> createState() => _NutritionInputScreenState();
}

class _NutritionInputScreenState extends State<NutritionInputScreen> {
  // Controller for the text input
  final TextEditingController _foodQueryController = TextEditingController();
  
  // List of selected nutrition items
  final List<Nutrition> _selectedNutritionItems = [];
  
  // Mock suggestions based on input
  List<Nutrition> _suggestions = [];
  
  @override
  void initState() {
    super.initState();
    // Initialize with empty suggestions
    _suggestions = [];
    
    // Listen for changes in input
    _foodQueryController.addListener(_updateSuggestions);
  }
  
  @override
  void dispose() {
    _foodQueryController.removeListener(_updateSuggestions);
    _foodQueryController.dispose();
    super.dispose();
  }
  
  // Update suggestions based on the input text
  void _updateSuggestions() {
    final query = _foodQueryController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }
    
    // Filter nutrition data based on query
    final allNutrition = Nutrition.getMockNutritionData();
    setState(() {
      _suggestions = allNutrition
          .where((item) => item.foodName.toLowerCase().contains(query))
          .toList();
    });
  }
  
  // Add a nutrition item to selected items
  void _addNutritionItem(Nutrition item) {
    setState(() {
      _selectedNutritionItems.add(item);
      _foodQueryController.clear();
      _suggestions = [];
    });
  }
  
  // Remove a nutrition item from selected items
  void _removeNutritionItem(int index) {
    setState(() {
      _selectedNutritionItems.removeAt(index);
    });
  }
  
  // Calculate total calories and macros
  Map<String, double> _calculateTotals() {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    
    for (var item in _selectedNutritionItems) {
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

  @override
  Widget build(BuildContext context) {
    // Calculate totals
    final totals = _calculateTotals();
    
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Nutrition Calculator'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Input section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instruction text
                  const Text(
                    'Enter foods to calculate nutrition:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Food input field
                  CupertinoTextField(
                    controller: _foodQueryController,
                    placeholder: 'Type a food (e.g., egg, chicken)...',
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Icon(
                        CupertinoIcons.search,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Suggestions section (only visible when there are suggestions)
            if (_suggestions.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    return SuggestionItem(
                      suggestion: _suggestions[index],
                      onAddItem: _addNutritionItem,
                    );
                  },
                ),
              ),
            
            // Summary section (total calories and macros)
            NutritionSummary(totals: totals),
            
            // Selected foods section
            Expanded(
              child: _selectedNutritionItems.isEmpty
                  ? const EmptyNutritionState()
                  : ListView.builder(
                      itemCount: _selectedNutritionItems.length,
                      itemBuilder: (context, index) {
                        return SelectedFoodItem(
                          nutrition: _selectedNutritionItems[index],
                          index: index,
                          onRemove: _removeNutritionItem,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
