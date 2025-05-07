import 'package:flutter/cupertino.dart';

class EmptyNutritionState extends StatelessWidget {
  const EmptyNutritionState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            CupertinoIcons.cart,
            size: 64,
            color: CupertinoColors.systemGrey,
          ),
          SizedBox(height: 16),
          Text(
            'No foods added yet',
            style: TextStyle(fontSize: 18, color: CupertinoColors.systemGrey),
          ),
          SizedBox(height: 8),
          Text(
            'Search and add foods to calculate nutrition',
            style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
          ),
        ],
      ),
    );
  }
}
