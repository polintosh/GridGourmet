import 'package:flutter/cupertino.dart';

class OriginMap extends StatelessWidget {
  final String area;

  const OriginMap({
    super.key,
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.map,
              size: 48,
              color: CupertinoColors.systemGrey,
            ),
            const SizedBox(height: 8),
            Text(
              'Map of $area',
              style: const TextStyle(
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}