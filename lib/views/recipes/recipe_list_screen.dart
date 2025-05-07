import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/recipe_viewmodel.dart';
import 'widgets/featured_recipe_card.dart';
import 'widgets/recipe_grid_item.dart';
import 'widgets/category_section.dart';

/// Screen for browsing recipes
/// Uses MVVM pattern by separating UI from business logic
class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ChangeNotifierProvider to provide the ViewModel
    return ChangeNotifierProvider(
      create: (_) => RecipeViewModel(),
      child: const _RecipeListScreenContent(),
    );
  }
}

/// Internal widget that consumes the ViewModel
class _RecipeListScreenContent extends StatelessWidget {
  const _RecipeListScreenContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(
      builder: (context, viewModel, child) {
        return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('Recipes'),
          ),
          child: SafeArea(
            child: viewModel.isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : viewModel.error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            viewModel.error!,
                            style: const TextStyle(color: CupertinoColors.destructiveRed),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : CustomScrollView(
                        slivers: [
                          // Search bar (optional)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CupertinoSearchTextField(
                                placeholder: 'Search recipes...',
                                onSubmitted: (query) {
                                  if (query.isNotEmpty) {
                                    viewModel.searchRecipes(query);
                                  }
                                },
                              ),
                            ),
                          ),
                          
                          // Heading for featured recipes
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
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
                              child: viewModel.featuredRecipes.isEmpty
                                  ? const Center(
                                      child: Text('No featured recipes found'),
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal, // Horizontal list
                                      itemCount: viewModel.featuredRecipes.length,
                                      itemBuilder: (context, index) {
                                        return FeaturedRecipeCard(
                                          recipe: viewModel.featuredRecipes[index],
                                        );
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
                            sliver: viewModel.recipes.isEmpty
                                ? const SliverToBoxAdapter(
                                    child: Center(
                                      child: Text('No recipes found'),
                                    ),
                                  )
                                : SliverGrid(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Two columns
                                      childAspectRatio: 0.75,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        return RecipeGridItem(
                                          recipe: viewModel.recipes[index],
                                        );
                                      },
                                      childCount: viewModel.recipes.length,
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
                          viewModel.categorizedRecipes.isEmpty
                              ? const SliverToBoxAdapter(
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text('No categories found'),
                                    ),
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      // Get category and its recipes
                                      final category = viewModel.categorizedRecipes.keys.elementAt(index);
                                      final categoryRecipes = viewModel.categorizedRecipes[category]!;
                                      
                                      // Return a category with its recipes
                                      return CategorySection(
                                        category: category,
                                        recipes: categoryRecipes,
                                      );
                                    },
                                    childCount: viewModel.categorizedRecipes.length,
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
      },
    );
  }
}
