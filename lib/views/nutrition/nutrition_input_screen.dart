import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/nutrition_viewmodel.dart';
import 'widgets/nutrition_summary.dart';
import 'widgets/empty_nutrition_state.dart';
import 'widgets/suggestion_item.dart';
import 'widgets/selected_food_item.dart';

/// Screen for inputting food items and calculating nutrition information
/// Uses MVVM pattern by separating UI from business logic
class NutritionInputScreen extends StatelessWidget {
  const NutritionInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ChangeNotifierProvider to provide the ViewModel
    return ChangeNotifierProvider(
      create: (_) => NutritionViewModel(),
      child: const _NutritionInputScreenContent(),
    );
  }
}

/// Internal widget that consumes the ViewModel
class _NutritionInputScreenContent extends StatefulWidget {
  const _NutritionInputScreenContent();

  @override
  State<_NutritionInputScreenContent> createState() => _NutritionInputScreenContentState();
}

class _NutritionInputScreenContentState extends State<_NutritionInputScreenContent> {
  // Controller for the text input
  final TextEditingController _foodQueryController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    // Listen for changes in input and update ViewModel
    _foodQueryController.addListener(() {
      Provider.of<NutritionViewModel>(context, listen: false)
        .setSearchQuery(_foodQueryController.text);
    });
  }
  
  @override
  void dispose() {
    _foodQueryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionViewModel>(
      builder: (context, viewModel, child) {
        // Calculate totals using the ViewModel
        final totals = viewModel.calculateTotals();
        
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
                
                // Loading indicator
                if (viewModel.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                
                // Error message
                if (viewModel.error != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      viewModel.error!,
                      style: const TextStyle(
                        color: CupertinoColors.destructiveRed,
                      ),
                    ),
                  ),
                
                // Suggestions section (only visible when there are suggestions)
                if (viewModel.suggestions.isNotEmpty)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewModel.suggestions.length,
                      itemBuilder: (context, index) {
                        return SuggestionItem(
                          suggestion: viewModel.suggestions[index],
                          onAddItem: viewModel.addNutritionItem,
                        );
                      },
                    ),
                  ),
                
                // Summary section (total calories and macros)
                NutritionSummary(totals: totals),
                
                // Selected foods section
                Expanded(
                  child: viewModel.selectedItems.isEmpty
                      ? const EmptyNutritionState()
                      : ListView.builder(
                          itemCount: viewModel.selectedItems.length,
                          itemBuilder: (context, index) {
                            return SelectedFoodItem(
                              nutrition: viewModel.selectedItems[index],
                              index: index,
                              onRemove: viewModel.removeNutritionItem,
                            );
                          },
                        ),
                ),
                
                // Clear all button (only visible when there are selected items)
                if (viewModel.selectedItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CupertinoButton(
                      color: CupertinoColors.systemRed,
                      onPressed: viewModel.clearSelectedItems,
                      child: const Text('Clear All'),
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
