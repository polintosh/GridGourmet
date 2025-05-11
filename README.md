# GridGourmet 🍽️  
**Your perfect recipe, served in style.**

![GridGourmet 001](https://github.com/user-attachments/assets/8021dffc-a08d-4de4-8dd6-3f0062236b51)

## 🚀 Project Status  
This project is **completed** and ready for use. All features have been implemented and tested to ensure a smooth user experience.

## 📱 About GridGourmet  
GridGourmet is a modern Flutter app that displays a collection of delicious recipes in a visually organized and user-friendly layout using both **lists** and **grids**. The app focuses on showcasing culinary content in a clean, structured interface, allowing users to browse, view, and explore dishes with ease.

This project was developed as part of an assignment to deepen our understanding of Flutter components and architecture.

## 📋 Lists & Grids: Core Layout Structure
GridGourmet uses various list and grid implementations as the fundamental building blocks of its UI:

### Vertical & Horizontal Lists
- **Recipe Category Lists**: Vertical scrolling lists organize recipes by category, with each category header followed by relevant recipes.
- **Featured Recipes Gallery**: Horizontal scrolling list (`ListView.builder` with `scrollDirection: Axis.horizontal`) showcases featured recipes with larger cards for visual emphasis.
- **Shopping List**: Vertical list of food ingredients with interactive checkboxes for meal planning.
- **Different Item Types**: Lists handle various content types through specialized item widgets for different data types and layouts.
- **Large Data Sets**: Optimized through `ListView.builder` for efficient rendering of only visible items, enabling smooth scrolling of extensive recipe collections.

### GridView Implementation
The core of the app's visual appeal comes from its grid layout implementation:

```dart
GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // Two columns
    childAspectRatio: 0.75,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemCount: viewModel.recipes.length,
  itemBuilder: (context, index) {
    return RecipeGridItem(recipe: viewModel.recipes[index]);
  },
)
```

This implementation creates a responsive two-column grid of recipe cards with customized spacing and aspect ratio for an aesthetically pleasing layout. By using `GridView.builder` inside a `SliverToBoxAdapter`, the app maintains the ability to combine this grid with other components in a `CustomScrollView` while simplifying the implementation.

### Technical Alternatives & Enhancements
- **StaggeredGridView**: A potential enhancement would be implementing a staggered grid for more dynamic layouts with varying item sizes.
- **Infinite Scrolling**: The current implementation could be extended with pagination for infinite scrolling of recipe data.
- **Responsive Adaptation**: The grid's `crossAxisCount` could dynamically adjust based on screen size for optimal viewing on different devices.
- **Animation Integration**: Grid items could incorporate staggered animations on load for a more engaging user experience.

## 🌟 Features

- **Recipe Exploration**: Browse recipes by categories, areas, or through search
- **Dual Interface**: View content in both list and grid layouts
- **Recipe Details**: Detailed information including ingredients, measures, and cooking instructions
- **Food Categories**: Explore different food items categorized for easy access
- **Favorites**: Mark recipes as favorites for quick access
- **iOS-Native Feel**: Built using CupertinoApp for authentic iOS design language

## 🏗️ Project Structure

```
lib/
├── main.dart                # App entry point
├── models/                  # Data models
│   ├── recipe.dart          # Recipe model
│   └── food.dart            # Food model
├── views/                   # UI screens and components
│   ├── recipes/             # Recipe-related screens
│   │   ├── recipe_list_screen.dart
│   │   ├── recipe_detail_screen.dart
│   │   └── widgets/
│   └── foods/               # Food-related screens
│       ├── food_list_screen.dart
│       └── widgets/
├── viewmodels/              # Business logic (MVVM architecture)
│   ├── recipe_viewmodel.dart
│   └── food_viewmodel.dart
├── services/                # API and data services
│   ├── recipe_service.dart  # TheMealDB API integration
│   └── food_service.dart    # Food data handling
└── utils/                   # Utility functions
    └── logger.dart          # Logging functionality
```

## 🛠️ Technologies & Architecture

- **Framework**: Flutter
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: Provider (integrated in ViewModels)
- **API Integration**: HTTP package for RESTful API calls
- **UI Components**: CupertinoApp for iOS-style interface
- **External API**: [TheMealDB API](https://www.themealdb.com/api.php) for recipe data

## 🔌 API Integration

GridGourmet integrates with TheMealDB API to fetch recipe data. The integration includes:

- Search recipes by name
- Filter recipes by category (e.g., Seafood, Vegetarian)
- Filter recipes by geographic area (e.g., Italian, Japanese)
- Get detailed recipe information including ingredients and instructions
- Fetch categories and areas for filtering options

## 🚀 Getting Started

1. Ensure you have Flutter installed on your machine
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Connect a device or start an emulator
5. Run `flutter run` to start the app

## 📖 Documentation  
You can follow the development and view the technical documentation here:  
👉 [GridGourmet Docs](https://polintosh.craft.me/sRBNDgr5Q89grG)

## 👨‍💻 Developer
GridGourmet is being developed by Pol Hernàndez.  
Visit my portfolio: [polintosh.vercel.app](https://polintosh.vercel.app)