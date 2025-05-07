import 'package:flutter/cupertino.dart';
import 'macro_item.dart';

class NutritionSummary extends StatelessWidget {
  final Map<String, double> totals;

  const NutritionSummary({
    super.key,
    required this.totals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              MacroItem(
                label: 'Protein',
                value: totals['protein']?.toStringAsFixed(1) ?? '0',
                unit: 'g',
                color: CupertinoColors.activeBlue,
              ),
              MacroItem(
                label: 'Carbs',
                value: totals['carbs']?.toStringAsFixed(1) ?? '0',
                unit: 'g',
                color: CupertinoColors.systemGreen,
              ),
              MacroItem(
                label: 'Fat',
                value: totals['fat']?.toStringAsFixed(1) ?? '0',
                unit: 'g',
                color: CupertinoColors.systemOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }
} 