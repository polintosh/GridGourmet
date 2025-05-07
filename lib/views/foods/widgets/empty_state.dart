import 'package:flutter/cupertino.dart';

class EmptyState extends StatelessWidget {
  final bool isShoppingList;

  const EmptyState({super.key, this.isShoppingList = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.cart,
            size: 64,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(height: 16),
          Text(
            isShoppingList ? 'Your shopping list is empty' : 'No foods found',
            style: const TextStyle(
              fontSize: 18,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isShoppingList
                ? 'Add items to your shopping list'
                : 'Try a different search term',
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
}
