import 'package:flutter/cupertino.dart';
import '../../models/food.dart';

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({super.key});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  // Mock state for shopping list items
  Map<String, bool> shoppingListItems = {};
  
  // Search text controller
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  
  // Tab index
  int _selectedTabIndex = 0;
  
  @override
  void initState() {
    super.initState();
    // Initialize shopping list with mock data
    final foods = Food.getMockFoods();
    for (var food in foods) {
      shoppingListItems[food.id] = food.isInShoppingList;
    }
    
    // Listen for changes in search text
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get mock foods
    final foods = Food.getMockFoods();
    
    // Filter foods by search text if any
    final filteredFoods = foods.where((food) {
      if (_searchText.isEmpty) {
        return true;
      }
      return food.name.toLowerCase().contains(_searchText.toLowerCase()) ||
          food.country.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
    
    // Only show foods in the shopping list for the second tab
    final shoppingListFoods = _selectedTabIndex == 1
        ? filteredFoods.where((food) => shoppingListItems[food.id] == true).toList()
        : filteredFoods;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Foods'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Search foods...',
              ),
            ),
            
            // Segmented control for tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoSegmentedControl<int>(
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('All Foods'),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Shopping List'),
                  ),
                },
                onValueChanged: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                groupValue: _selectedTabIndex,
              ),
            ),
            
            // Main content - list of foods
            Expanded(
              child: shoppingListFoods.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: shoppingListFoods.length,
                      itemBuilder: (context, index) {
                        return _buildFoodItem(shoppingListFoods[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget for empty state when no foods match the criteria
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.cart,
            size: 64,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(height: 16),
          Text(
            _selectedTabIndex == 0
                ? 'No foods found'
                : 'Your shopping list is empty',
            style: const TextStyle(
              fontSize: 18,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedTabIndex == 0
                ? 'Try a different search term'
                : 'Add items to your shopping list',
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget for food item in the list
  Widget _buildFoodItem(Food food) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          // Checkbox for shopping list
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              shoppingListItems[food.id] == true
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.circle,
              color: shoppingListItems[food.id] == true
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.systemGrey,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                shoppingListItems[food.id] = !(shoppingListItems[food.id] ?? false);
              });
            },
          ),
          const SizedBox(width: 12),
          
          // Food image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              food.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          
          // Food info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food name
                Text(
                  food.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: shoppingListItems[food.id] == true && _selectedTabIndex == 1
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Food origin
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.globe,
                      size: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Origin: ${food.country}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Nutrition grade
                Row(
                  children: [
                    Icon(
                      _getNutritionIcon(food.nutritionGrade),
                      size: 14,
                      color: _getNutritionColor(food.nutritionGrade),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Nutrition Grade: ${food.nutritionGrade.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: _getNutritionColor(food.nutritionGrade),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Info button
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.info_circle,
              color: CupertinoColors.systemGrey,
            ),
            onPressed: () {
              _showFoodDetails(food);
            },
          ),
        ],
      ),
    );
  }
  
  // Helper to get nutrition grade icon
  IconData _getNutritionIcon(String grade) {
    switch (grade.toLowerCase()) {
      case 'a':
        return CupertinoIcons.heart_fill;
      case 'b':
        return CupertinoIcons.heart;
      case 'c':
        return CupertinoIcons.exclamationmark_circle;
      case 'd':
      case 'e':
        return CupertinoIcons.exclamationmark_triangle_fill;
      default:
        return CupertinoIcons.question_circle;
    }
  }
  
  // Helper to get nutrition grade color
  Color _getNutritionColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'a':
        return CupertinoColors.systemGreen;
      case 'b':
        return CupertinoColors.activeBlue;
      case 'c':
        return CupertinoColors.systemYellow;
      case 'd':
        return CupertinoColors.systemOrange;
      case 'e':
        return CupertinoColors.systemRed;
      default:
        return CupertinoColors.systemGrey;
    }
  }
  
  // Show food details in a modal
  void _showFoodDetails(Food food) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.xmark_circle),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Food image and basic info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    food.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Origin: ${food.country}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Nutrition Grade: ',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getNutritionColor(food.nutritionGrade),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            food.nutritionGrade.toUpperCase(),
                            style: const TextStyle(
                              color: CupertinoColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Ingredients section
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              food.ingredients,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // Add to shopping list button
            CupertinoButton.filled(
              onPressed: () {
                setState(() {
                  shoppingListItems[food.id] = true;
                });
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.cart_badge_plus),
                  const SizedBox(width: 8),
                  const Text('Add to Shopping List'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
