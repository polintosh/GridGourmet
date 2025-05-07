import 'package:flutter/cupertino.dart';

class IngredientItem extends StatelessWidget {
  final String ingredient;
  final String measure;
  
  const IngredientItem({
    super.key, 
    required this.ingredient, 
    required this.measure,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.check_mark_circled,
            color: CupertinoColors.activeGreen,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ingredient,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            measure,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 