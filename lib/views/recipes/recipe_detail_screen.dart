import 'package:flutter/cupertino.dart';
import '../../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(recipe.name),
        // Add a favorite button
        trailing: GestureDetector(
          onTap: () {
            // In a real app, we would toggle favorite status
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('Added to favorites'),
                content: Text('${recipe.name} has been added to your favorites.'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          },
          child: const Icon(CupertinoIcons.heart),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            // Hero image
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.network(
                recipe.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
            
            // Recipe info section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe metadata
                  Row(
                    children: [
                      _buildInfoChip(CupertinoIcons.globe, recipe.area),
                      const SizedBox(width: 8),
                      _buildInfoChip(CupertinoIcons.tag, recipe.category),
                      const SizedBox(width: 8),
                      _buildInfoChip(CupertinoIcons.time, '30 min'), // Mock time
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Instructions heading
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Instructions
                  Text(
                    recipe.instructions,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Ingredients heading
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Ingredients list
                  ...List.generate(
                    recipe.ingredients.length,
                    (index) => _buildIngredientItem(
                      recipe.ingredients[index],
                      recipe.measures[index],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Origin section
                  const Text(
                    'Origin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Origin info
                  Text(
                    'This dish originates from ${recipe.area} cuisine.',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  
                  // Here we would show a map with the origin (for geolocation feature)
                  Container(
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
                            'Map of ${recipe.area}',
                            style: const TextStyle(
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ],
                      ),
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
  
  // Helper widget for info chips
  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: CupertinoColors.activeBlue,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper widget for ingredient items
  Widget _buildIngredientItem(String ingredient, String measure) {
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
