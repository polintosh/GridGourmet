import 'package:flutter/cupertino.dart';
import '../../../models/food.dart';

/// Food item widget that displays food information in a list
/// Uses MVVM pattern by only handling UI concerns
class FoodItem extends StatelessWidget {
  final Food food;
  final bool isInShoppingList;
  final Function(String) onToggleShoppingList;

  const FoodItem({
    super.key,
    required this.food,
    required this.isInShoppingList,
    required this.onToggleShoppingList,
  });
  
  /// Helper method for category icon
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'beef': return CupertinoIcons.cube_box;
      case 'chicken': return CupertinoIcons.heart_fill;
      case 'dessert': return CupertinoIcons.gift_fill;
      case 'lamb': return CupertinoIcons.square_stack_3d_down_right;
      case 'pasta': return CupertinoIcons.circle_grid_hex;
      case 'pork': return CupertinoIcons.circle_grid_3x3;
      case 'seafood': return CupertinoIcons.drop_fill;
      case 'side': return CupertinoIcons.square_split_2x2;
      case 'starter': return CupertinoIcons.flag_fill;
      case 'vegan': return CupertinoIcons.arrow_3_trianglepath;
      case 'vegetarian': return CupertinoIcons.tree;
      case 'breakfast': return CupertinoIcons.sunrise_fill;
      case 'goat': return CupertinoIcons.circle_grid_hex_fill;
      case 'miscellaneous': 
      default: return CupertinoIcons.square_grid_2x2;
    }
  }
  
  /// Helper method for category color
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'beef': return CupertinoColors.systemRed;
      case 'chicken': return CupertinoColors.systemOrange;
      case 'dessert': return CupertinoColors.systemPink;
      case 'lamb': return CupertinoColors.systemPurple;
      case 'pasta': return CupertinoColors.systemYellow;
      case 'pork': return CupertinoColors.systemBrown;
      case 'seafood': return CupertinoColors.systemBlue;
      case 'side': return CupertinoColors.systemTeal;
      case 'starter': return CupertinoColors.systemGreen;
      case 'vegan': 
      case 'vegetarian': return CupertinoColors.activeGreen;
      case 'breakfast': return CupertinoColors.systemIndigo;
      case 'goat': return CupertinoColors.systemPurple;
      default: return CupertinoColors.systemGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox for shopping list
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              isInShoppingList
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.circle,
              color: isInShoppingList
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.systemGrey,
              size: 28,
            ),
            onPressed: () => onToggleShoppingList(food.id),
          ),
          const SizedBox(width: 12),
          
          // Food image - using error handling for image loading
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              food.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: CupertinoColors.systemGrey5,
                  child: const Icon(
                    CupertinoIcons.photo,
                    color: CupertinoColors.systemGrey,
                  ),
                );
              },
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
                    decoration: isInShoppingList ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                    Flexible(
                      child: Text(
                        'Origin: ${food.country}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Meal category
                Row(
                  children: [
                    Icon(
                      _getCategoryIcon(food.category),
                      size: 14,
                      color: _getCategoryColor(food.category),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Category: ${food.category.isNotEmpty ? food.category : 'Unknown'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _getCategoryColor(food.category),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 