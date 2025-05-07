class Recipe {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnailUrl;
  final List<String> ingredients;
  final List<String> measures;
  final bool isFavorite;

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

  // Mock data factory
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
