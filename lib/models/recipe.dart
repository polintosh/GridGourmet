/// Represents a recipe with cooking instructions and ingredients
/// This class serves as the Model in the MVVM architecture
class Recipe {
  /// Unique identifier for the recipe
  final String id;
  
  /// Name of the recipe
  final String name;
  
  /// Category of the recipe (e.g., Seafood, Vegetarian)
  final String category;
  
  /// Geographic origin of the recipe
  final String area;
  
  /// Step-by-step cooking instructions
  final String instructions;
  
  /// URL to the recipe image
  final String thumbnailUrl;
  
  /// List of ingredients required for the recipe
  final List<String> ingredients;
  
  /// Measurements for each ingredient
  final List<String> measures;
  
  /// Whether the recipe is marked as favorite
  final bool isFavorite;

  /// Constructor for creating a Recipe object
  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnailUrl,
    required this.ingredients,
    required this.measures,
    this.isFavorite = false,
  });

  /// Factory method to create a Recipe object from TheMealDB JSON data
  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Extract ingredients and measures
    List<String> ingredients = [];
    List<String> measures = [];
    
    for (int i = 1; i <= 20; i++) {
      String ingredient = json['strIngredient$i'] ?? '';
      String measure = json['strMeasure$i'] ?? '';
      
      if (ingredient.trim().isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure.trim().isNotEmpty ? measure : '');
      }
    }
    
    return Recipe(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbnailUrl: json['strMealThumb'] ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }

  /// Convert Recipe object to JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': thumbnailUrl,
      'isFavorite': isFavorite,
    };
    
    // Add ingredients and measures
    for (int i = 0; i < ingredients.length; i++) {
      json['strIngredient${i + 1}'] = ingredients[i];
      json['strMeasure${i + 1}'] = i < measures.length ? measures[i] : '';
    }
    
    return json;
  }

  /// Create a copy of this Recipe with modified properties
  Recipe copyWith({
    String? id,
    String? name,
    String? category,
    String? area,
    String? instructions,
    String? thumbnailUrl,
    List<String>? ingredients,
    List<String>? measures,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      area: area ?? this.area,
      instructions: instructions ?? this.instructions,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      ingredients: ingredients ?? this.ingredients,
      measures: measures ?? this.measures,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Generate mock recipe data for testing and development
  static List<Recipe> getMockRecipes() {
    return [
      Recipe(
        id: '1',
        name: 'Teriyaki Chicken Casserole',
        category: 'Chicken',
        area: 'Japanese',
        instructions: 'Preheat oven to 350° F. Spray a 9x13-inch baking pan with non-stick spray...',
        thumbnailUrl: 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
        ingredients: ['Chicken', 'Broccoli', 'Rice', 'Soy Sauce', 'Teriyaki Sauce'],
        measures: ['3 cups', '2 cups', '4 cups', '3 tbsp', '1/4 cup'],
      ),
      Recipe(
        id: '2',
        name: 'Mediterranean Pasta Salad',
        category: 'Seafood',
        area: 'Italian',
        instructions: 'Bring a large saucepan of salted water to the boil. Add the pasta, stir once and cook for about 10 minutes...',
        thumbnailUrl: 'https://www.themealdb.com/images/media/meals/wvqpwt1468339226.jpg',
        ingredients: ['Pasta', 'Tomatoes', 'Olives', 'Feta Cheese', 'Olive Oil'],
        measures: ['2 cups', '3', '1/2 cup', '1/2 cup', '2 tbsp'],
      ),
      Recipe(
        id: '3',
        name: 'Vegetable Curry',
        category: 'Vegetarian',
        area: 'Indian',
        instructions: 'Heat oil in a large saucepan over medium heat. Cook onion and garlic, stirring...',
        thumbnailUrl: 'https://www.themealdb.com/images/media/meals/wuprvu1511923181.jpg',
        ingredients: ['Cauliflower', 'Chickpeas', 'Coconut Milk', 'Curry Powder', 'Rice'],
        measures: ['1 head', '1 can', '1 can', '2 tbsp', '2 cups'],
      ),
      Recipe(
        id: '4',
        name: 'Beef Bourguignon',
        category: 'Beef',
        area: 'French',
        instructions: 'Heat the oil in a large pan. Add the bacon and fry until crisp...',
        thumbnailUrl: 'https://www.themealdb.com/images/media/meals/vtqxtu1511784197.jpg',
        ingredients: ['Beef', 'Bacon', 'Red Wine', 'Onion', 'Carrots'],
        measures: ['1 kg', '200g', '1 bottle', '2', '2'],
      ),
      Recipe(
        id: '5',
        name: 'Fish Tacos',
        category: 'Seafood',
        area: 'Mexican',
        instructions: 'Preheat grill to medium-high heat. Brush fish with oil and season with cumin, salt, and pepper...',
        thumbnailUrl: 'https://www.themealdb.com/images/media/meals/uvuyxu1503067369.jpg',
        ingredients: ['White Fish', 'Tortillas', 'Avocado', 'Lime', 'Cilantro'],
        measures: ['1 lb', '8', '2', '2', '1/4 cup'],
      ),
      Recipe(
        id: '6',
        name: 'Miso Ramen',
        category: 'Pork',
        area: 'Japanese',
        instructions: 'Heat oil in a large pot over medium heat. Add garlic and ginger...',
        thumbnailUrl: 'https://www.themealdb.com/images/media/meals/1529446137.jpg',
        ingredients: ['Ramen Noodles', 'Miso Paste', 'Pork Belly', 'Egg', 'Green Onions'],
        measures: ['200g', '2 tbsp', '100g', '2', '3'],
      ),
    ];
  }
}
