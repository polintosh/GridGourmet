import 'package:flutter/cupertino.dart';
import 'views/recipes/recipe_list_screen.dart';
import 'views/foods/food_list_screen.dart';
import 'views/nutrition/nutrition_input_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // CupertinoApp is used to give the app an iOS-like appearance.
    return CupertinoApp(
      title: 'GridGourmet',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemOrange,
      ),
      home: CupertinoTabScaffold(
        // The tab bar with icons and labels for navigation.
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.book),
              label: 'Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cart),
              label: 'Foods',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar),
              label: 'Nutrition',
            ),
          ],
        ),
        // This builder returns the content for each tab index.
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(builder: (context) => RecipeListScreen());
            case 1:
              return CupertinoTabView(builder: (context) => FoodListScreen());
            case 2:
              return CupertinoTabView(
                builder: (context) => NutritionInputScreen(),
              );
            default:
              return CupertinoTabView(builder: (context) => RecipeListScreen());
          }
        },
      ),
    );
  }
}
