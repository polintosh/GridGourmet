import 'package:flutter/cupertino.dart';
import '../../models/food.dart';
import 'widgets/food_item.dart';
import 'widgets/empty_state.dart';

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

  // Toggle shopping list status
  void _toggleShoppingListItem(String foodId) {
    setState(() {
      shoppingListItems[foodId] = !(shoppingListItems[foodId] ?? false);
    });
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
                  ? EmptyState(isShoppingList: _selectedTabIndex == 1)
                  : ListView.builder(
                      itemCount: shoppingListFoods.length,
                      itemBuilder: (context, index) {
                        final food = shoppingListFoods[index];
                        final isInShoppingList = shoppingListItems[food.id] == true && _selectedTabIndex == 1;
                        return FoodItem(
                          food: food,
                          isInShoppingList: isInShoppingList,
                          onToggleShoppingList: _toggleShoppingListItem,
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
