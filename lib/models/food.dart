/// Represents a food/meal product with nutritional and origin information
/// This class serves as the Model in the MVVM architecture
class Food {
  /// Unique identifier for the food product
  final String id;
  
  /// Name of the food product
  final String name;
  
  /// URL to the product image
  final String imageUrl;
  
  /// Country of origin for the food product
  final String country;
  
  /// List of ingredients in the food product
  final String ingredients;
  
  /// Category of the meal (from TheMealDB)
  final String category;
  
  /// Whether the food is in the user's shopping list
  final bool isInShoppingList;

  /// Constructor for creating a Food object
  Food({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.country,
    required this.ingredients,
    this.category = '',
    this.isInShoppingList = false,
  });

  /// Factory method to create a Food object from TheMealDB JSON data
  factory Food.fromTheMealDBJson(Map<String, dynamic> json) {
    return Food(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      country: json['strArea'] ?? '',
      ingredients: _parseIngredientsFromMealDB(json),
      category: json['strCategory'] ?? '',
    );
  }

  /// Helper method to parse ingredients from TheMealDB response
  static String _parseIngredientsFromMealDB(Map<String, dynamic> json) {
    final List<String> ingredients = [];
    
    // TheMealDB has ingredients as strIngredient1, strIngredient2, etc.
    // with corresponding measures as strMeasure1, strMeasure2, etc.
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        final measureText = (measure != null && measure.toString().trim().isNotEmpty) 
            ? '$measure ' 
            : '';
        ingredients.add('$measureText$ingredient');
      }
    }
    
    return ingredients.join(', ');
  }

  /// Convert Food object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'country': country,
      'ingredients': ingredients,
      'category': category,
      'is_in_shopping_list': isInShoppingList,
    };
  }

  /// Create a copy of this Food with modified properties
  Food copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? country,
    String? ingredients,
    String? category,
    bool? isInShoppingList,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      country: country ?? this.country,
      ingredients: ingredients ?? this.ingredients,
      category: category ?? this.category,
      isInShoppingList: isInShoppingList ?? this.isInShoppingList,
    );
  }

  /// Generate mock food data for testing and development
  /// Uses actual meals from TheMealDB
  static List<Food> getMockFoods() {
    return [
      Food(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
        imageUrl: 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
        country: 'Japanese',
        ingredients: '3/4 cup soy sauce, 1/2 cup water, 1/4 cup brown sugar, 1/2 teaspoon ground ginger, 1/2 teaspoon minced garlic, 4 Tablespoons cornstarch, 2 chicken breasts, 1 cup broccoli, 1 cup carrots, 1 cup green beans, 3 cups rice',
        category: 'Chicken',
      ),
      Food(
        id: '52773',
        name: 'Honey Teriyaki Salmon',
        imageUrl: 'https://www.themealdb.com/images/media/meals/xxyupu1468262513.jpg',
        country: 'Japanese',
        ingredients: '1 lb salmon, 1 tablespoon olive oil, 2 tablespoons soy sauce, 2 tablespoons honey, 1 tablespoon rice vinegar, 1 teaspoon sesame oil, 1 teaspoon ginger, grated, 1 teaspoon garlic, grated, 1 tablespoon sesame seed, 1 green onion, sliced thin',
        category: 'Seafood',
      ),
      Food(
        id: '52770',
        name: 'Spaghetti Bolognese',
        imageUrl: 'https://www.themealdb.com/images/media/meals/sutysw1468247559.jpg',
        country: 'Italian',
        ingredients: '1 tbsp olive oil, 4 rashers smoked streaky bacon, 2 onions, 2 garlic cloves, 500g beef mince, 1 wine glass red wine, 400g tin chopped tomatoes, 1 tbsp tomato purée, 1 beef stock cube, 1 tsp dried oregano, 400g spaghetti, Parmesan cheese',
        category: 'Beef',
      ),
      Food(
        id: '52771',
        name: 'Spicy Arrabiata Penne',
        imageUrl: 'https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg',
        country: 'Italian',
        ingredients: '1 pound penne rigate, 1/4 cup olive oil, 3 cloves garlic, 1 tin chopped tomatoes, 1/2 teaspoon red chile flakes, 1/2 teaspoon Italian seasoning, 6 leaves basil, spinkling Parmigiano-Reggiano',
        category: 'Vegetarian',
      ),
      Food(
        id: '52775',
        name: 'Lamb Biryani',
        imageUrl: 'https://www.themealdb.com/images/media/meals/xrttsx1487339558.jpg',
        country: 'Indian',
        ingredients: '300g basmati rice, 25g butter, 1 large onion, 1 bay leaf, 3 cardamom pods, small cinnamon stick, 1 tsp turmeric, 4 skinless chicken breasts, 4 tbsp curry paste, 85g raisins, 850ml chicken stock, chopped coriander and toasted flaked almonds to garnish',
        category: 'Lamb',
      ),
      Food(
        id: '52785',
        name: 'Dal fry',
        imageUrl: 'https://www.themealdb.com/images/media/meals/wuxrtu1483564410.jpg',
        country: 'Indian',
        ingredients: '1 cup Yellow Lentils, 1/2 tsp Turmeric, 1 tsp Garlic, 1 tsp Ginger, 1 Green Chili, 1 Medium Onion, 1 Medium Tomato, 2 tsp Cumin Seeds, 1 tsp Mustard Seeds, 1 tsp Coriander Powder, 1 tsp Garam Masala, 2 Dried Red Chili, 1 tsp Salt, 1 tsp Sugar, 3 tsp Oil, Water As Required',
        category: 'Vegetarian',
      ),
      Food(
        id: '52874',
        name: 'Beef and Mustard Pie',
        imageUrl: 'https://www.themealdb.com/images/media/meals/sytuqu1511553755.jpg',
        country: 'British',
        ingredients: '400g Beef, 2 tbs Plain Flour, 2 tbs Rapeseed Oil, 200ml Red Wine, 400ml Beef Stock, 1 Onion, 2 Carrots, 2 tbs Mustard, 2 tbs Worcestershire Sauce, 1 Bay Leaf, 300g Puff Pastry, 1 Egg Yolk', 
        category: 'Beef',
      ),
      Food(
        id: '52804',
        name: 'Poutine',
        imageUrl: 'https://www.themealdb.com/images/media/meals/uuyrrx1487327597.jpg',
        country: 'Canadian',
        ingredients: '2 lbs Potatoes, 1/4 lb Butter, 1/4 cup Beef Stock, 1/4 cup All-Purpose Flour, 2 cups Canola Oil, 2 cups Cheese Curds, Salt, Pepper',
        category: 'Miscellaneous',
      ),
    ];
  }
}
