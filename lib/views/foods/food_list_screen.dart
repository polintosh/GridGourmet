import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/food_viewmodel.dart';
import 'widgets/food_item.dart';
import 'widgets/empty_state.dart';

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ChangeNotifierProvider to provide the ViewModel to the widget tree
    return ChangeNotifierProvider(
      create: (_) => FoodViewModel(),
      child: const _FoodListScreenContent(),
    );
  }
}

/// Internal widget that consumes the ViewModel
class _FoodListScreenContent extends StatefulWidget {
  const _FoodListScreenContent();

  @override
  State<_FoodListScreenContent> createState() => _FoodListScreenContentState();
}

class _FoodListScreenContentState extends State<_FoodListScreenContent> {
  // Search text controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Listen for changes in search text and update ViewModel
    _searchController.addListener(() {
      Provider.of<FoodViewModel>(
        context,
        listen: false,
      ).setSearchText(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Show dropdown menu for filtering options
  void _showFilterMenu(BuildContext context, FoodViewModel viewModel) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => CupertinoActionSheet(
            title: const Text('Filter Foods'),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                isDefaultAction: viewModel.selectedTabIndex == 0,
                onPressed: () {
                  viewModel.setSelectedTabIndex(0);
                  Navigator.pop(context);
                },
                child: const Text('All Foods'),
              ),
              CupertinoActionSheetAction(
                isDefaultAction: viewModel.selectedTabIndex == 1,
                onPressed: () {
                  viewModel.setSelectedTabIndex(1);
                  Navigator.pop(context);
                },
                child: const Text('Shopping List'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodViewModel>(
      builder: (context, viewModel, child) {
        // Get filtered shopping list foods from ViewModel
        final shoppingListFoods = viewModel.shoppingListFoods;

        // Choose icon based on selected tab
        final leadingIcon =
            viewModel.selectedTabIndex == 0
                ? CupertinoIcons.list_bullet
                : CupertinoIcons.cart;

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('Foods'),
            // Use an icon button that shows a menu when tapped
            leading: GestureDetector(
              onTap: () => _showFilterMenu(context, viewModel),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(leadingIcon, color: CupertinoColors.activeBlue),
              ),
            ),
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

                // Show loading indicator when data is loading
                if (viewModel.isLoading)
                  const Expanded(
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                // Show error message when there is an error
                else if (viewModel.error != null)
                  Expanded(
                    child: Center(
                      child: Text(
                        viewModel.error!,
                        style: const TextStyle(
                          color: CupertinoColors.destructiveRed,
                        ),
                      ),
                    ),
                  )
                // Main content - list of foods
                else
                  Expanded(
                    child:
                        shoppingListFoods.isEmpty
                            ? EmptyState(
                              isShoppingList: viewModel.selectedTabIndex == 1,
                            )
                            : ListView.builder(
                              itemCount: shoppingListFoods.length,
                              itemBuilder: (context, index) {
                                final food = shoppingListFoods[index];
                                final isInShoppingList =
                                    viewModel.shoppingListItems[food.id] ==
                                    true;
                                return FoodItem(
                                  food: food,
                                  isInShoppingList: isInShoppingList,
                                  onToggleShoppingList:
                                      viewModel.toggleShoppingListItem,
                                );
                              },
                            ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
