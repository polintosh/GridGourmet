import 'package:flutter/cupertino.dart';
import '../../models/recipe.dart';
import 'widgets/info_chip.dart';
import 'widgets/ingredient_item.dart';
import 'widgets/origin_map.dart';

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
                      InfoChip(icon: CupertinoIcons.globe, label: recipe.area),
                      const SizedBox(width: 8),
                      InfoChip(icon: CupertinoIcons.tag, label: recipe.category),
                      const SizedBox(width: 8),
                      const InfoChip(icon: CupertinoIcons.time, label: '30 min'), // Mock time
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
                    (index) => IngredientItem(
                      ingredient: recipe.ingredients[index],
                      measure: recipe.measures[index],
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
                  
                  // Map with the origin
                  OriginMap(area: recipe.area),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
