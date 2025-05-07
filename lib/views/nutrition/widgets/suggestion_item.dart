import 'package:flutter/cupertino.dart';
import '../../../models/nutrition.dart';

class SuggestionItem extends StatelessWidget {
  final Nutrition suggestion;
  final Function(Nutrition) onAddItem;

  const SuggestionItem({
    super.key,
    required this.suggestion,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onAddItem(suggestion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.systemGrey5,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.add_circled,
              color: CupertinoColors.activeBlue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.foodName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${suggestion.calories} cal | ${suggestion.protein}g protein',
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 