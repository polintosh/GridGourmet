import 'package:flutter/cupertino.dart';
import '../../../models/nutrition.dart';

class SelectedFoodItem extends StatelessWidget {
  final Nutrition nutrition;
  final int index;
  final Function(int) onRemove;

  const SelectedFoodItem({
    super.key, 
    required this.nutrition,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Food info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nutrition.foodName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Calories: ${nutrition.calories} cal',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'P: ${nutrition.protein}g',
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'C: ${nutrition.carbs}g',
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'F: ${nutrition.totalFat}g',
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Remove button
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.minus_circle,
              color: CupertinoColors.systemRed,
            ),
            onPressed: () => onRemove(index),
          ),
        ],
      ),
    );
  }
} 