import 'package:flutter/cupertino.dart';
import '../../models/recipe.dart';
import 'recipe_detail_screen.dart';

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
                    return _buildFeaturedRecipeCard(context, recipes[index]);
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
                    return _buildRecipeGridItem(context, recipes[index]);
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
                  return _buildCategorySection(context, category, categoryRecipes);
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
  
  // Widget for horizontal featured recipe card
  Widget _buildFeaturedRecipeCard(BuildContext context, Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(left: 16, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                recipe.thumbnailUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            // Recipe name
            Text(
              recipe.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Recipe origin
            Text(
              '${recipe.category} • ${recipe.area}',
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget for grid item
  Widget _buildRecipeGridItem(BuildContext context, Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                recipe.thumbnailUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Recipe name
          Text(
            recipe.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Recipe origin
          Text(
            recipe.area,
            style: const TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget for category section (different item type)
  Widget _buildCategorySection(BuildContext context, String category, List<Recipe> recipes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category name
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // List of recipes in this category
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return _buildCategoryRecipeItem(context, recipes[index]);
          },
        ),
      ],
    );
  }
  
  // Widget for recipe item in category
  Widget _buildCategoryRecipeItem(BuildContext context, Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Recipe image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                recipe.thumbnailUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Recipe info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.area,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.time,
                        size: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '30 min', // Mock cooking time
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Chevron icon
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }
}
