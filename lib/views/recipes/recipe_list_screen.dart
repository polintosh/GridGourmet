import 'package:flutter/cupertino.dart';
import '../../models/recipe.dart';
import 'widgets/featured_recipe_card.dart';
import 'widgets/recipe_grid_item.dart';
import 'widgets/category_section.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get mock recipes
    final recipes = Recipe.getMockRecipes();
    // Create category groups for our different sections
    final Map<String, List<Recipe>> categorizedRecipes = {};
    
    for (var recipe in recipes) {
      if (!categorizedRecipes.containsKey(recipe.category)) {
        categorizedRecipes[recipe.category] = [];
      }
      categorizedRecipes[recipe.category]!.add(recipe);
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Recipes'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Heading for featured recipes
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Featured Recipes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Horizontal list of featured recipes
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Horizontal list
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return FeaturedRecipeCard(recipe: recipes[index]);
                  },
                ),
              ),
            ),
            
            // Heading for recipes grid
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'All Recipes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Grid of all recipes
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return RecipeGridItem(recipe: recipes[index]);
                  },
                  childCount: recipes.length,
                ),
              ),
            ),
            
            // Heading for recipes by category (different item types)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Recipes by Category',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // List with different types of items (categories with recipes)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Get category and its recipes
                  final category = categorizedRecipes.keys.elementAt(index);
                  final categoryRecipes = categorizedRecipes[category]!;
                  
                  // Return a category with its recipes
                  return CategorySection(
                    category: category,
                    recipes: categoryRecipes,
                  );
                },
                childCount: categorizedRecipes.length,
              ),
            ),
            
            // Add some space at the bottom
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }
}
