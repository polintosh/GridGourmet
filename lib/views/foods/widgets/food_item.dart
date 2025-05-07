import 'package:flutter/cupertino.dart';
import '../../../models/food.dart';

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
  
  // Helper method for nutrition icon
  IconData _getNutritionIcon(String grade) {
    switch (grade.toLowerCase()) {
      case 'a': return CupertinoIcons.star_fill;
      case 'b': return CupertinoIcons.star;
      case 'c': return CupertinoIcons.star_lefthalf_fill;
      case 'd': return CupertinoIcons.exclamationmark_circle;
      case 'e': return CupertinoIcons.exclamationmark_triangle;
      default: return CupertinoIcons.question_circle;
    }
  }
  
  // Helper method for nutrition color
  Color _getNutritionColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'a': return CupertinoColors.systemGreen;
      case 'b': return CupertinoColors.activeGreen;
      case 'c': return CupertinoColors.systemYellow;
      case 'd': return CupertinoColors.systemOrange;
      case 'e': return CupertinoColors.systemRed;
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
                    decoration: isInShoppingList ? TextDecoration.lineThrough : null,
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