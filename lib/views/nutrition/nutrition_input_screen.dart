import 'package:flutter/cupertino.dart';
import '../../models/nutrition.dart';

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
                    return _buildSuggestionItem(_suggestions[index]);
                  },
                ),
              ),
            
            // Summary section (total calories and macros)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Total calories
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.flame_fill,
                        color: CupertinoColors.systemOrange,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${totals['calories']?.toStringAsFixed(0) ?? '0'} calories',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Macronutrients
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMacroItem(
                        'Protein',
                        totals['protein']?.toStringAsFixed(1) ?? '0',
                        'g',
                        CupertinoColors.activeBlue,
                      ),
                      _buildMacroItem(
                        'Carbs',
                        totals['carbs']?.toStringAsFixed(1) ?? '0',
                        'g',
                        CupertinoColors.systemGreen,
                      ),
                      _buildMacroItem(
                        'Fat',
                        totals['fat']?.toStringAsFixed(1) ?? '0',
                        'g',
                        CupertinoColors.systemOrange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Selected foods section
            Expanded(
              child: _selectedNutritionItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _selectedNutritionItems.length,
                      itemBuilder: (context, index) {
                        return _buildSelectedFoodItem(
                          _selectedNutritionItems[index],
                          index,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget for empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            CupertinoIcons.cart,
            size: 64,
            color: CupertinoColors.systemGrey,
          ),
          SizedBox(height: 16),
          Text(
            'No foods added yet',
            style: TextStyle(
              fontSize: 18,
              color: CupertinoColors.systemGrey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start typing above to add foods',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget for a macro nutrient display
  Widget _buildMacroItem(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$label ($unit)',
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
  
  // Widget for suggestion item
  Widget _buildSuggestionItem(Nutrition item) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _addNutritionItem(item),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.systemGrey5,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Food image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Food info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.foodName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${item.calories.toStringAsFixed(0)} cal | ${item.servingWeight}g per ${item.servingUnit}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            // Add icon
            const Icon(
              CupertinoIcons.add_circled,
              color: CupertinoColors.activeBlue,
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget for selected food item
  Widget _buildSelectedFoodItem(Nutrition item, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey5,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Food image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Food info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.foodName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.servingWeight}g | ${item.servingUnit}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          // Nutrition info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.calories.toStringAsFixed(0)} cal',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'P: ${item.protein}g | C: ${item.carbs}g | F: ${item.totalFat}g',
                style: const TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
          // Remove button
          CupertinoButton(
            padding: const EdgeInsets.only(left: 8),
            onPressed: () => _removeNutritionItem(index),
            child: const Icon(
              CupertinoIcons.delete,
              color: CupertinoColors.systemRed,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
