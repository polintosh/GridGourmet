import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../models/recipe.dart';
import '../../viewmodels/recipe_viewmodel.dart';
import 'widgets/info_chip.dart';
import 'widgets/ingredient_item.dart';
import 'widgets/origin_map.dart';

/// Screen showing recipe details
/// Uses MVVM pattern by connecting with the RecipeViewModel
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(recipe.name),
        // Add a favorite button that connects to the ViewModel
        trailing: Consumer<RecipeViewModel>(
          builder: (context, viewModel, child) {
            return GestureDetector(
              onTap: () {
                // Toggle favorite in the ViewModel
                viewModel.toggleFavorite(recipe.id);
                
                // Show a confirmation dialog
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text(
                      recipe.isFavorite 
                          ? 'Removed from favorites' 
                          : 'Added to favorites'
                    ),
                    content: Text(
                      recipe.isFavorite
                          ? '${recipe.name} has been removed from your favorites.'
                          : '${recipe.name} has been added to your favorites.'
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              },
              child: Icon(
                recipe.isFavorite 
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                color: recipe.isFavorite
                    ? CupertinoColors.systemRed
                    : null,
              ),
            );
          },
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
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: CupertinoColors.systemGrey5,
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.photo,
                        size: 64,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  );
                },
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
                      measure: index < recipe.measures.length 
                          ? recipe.measures[index]
                          : '',
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
