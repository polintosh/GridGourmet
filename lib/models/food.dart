class Food {
  final String id;
  final String name;
  final String imageUrl;
  final String country;
  final String ingredients;
  final String nutritionGrade;
  final bool isInShoppingList;

  Food({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.country,
    required this.ingredients,
    required this.nutritionGrade,
    this.isInShoppingList = false,
  });

  // Mock data factory
  static List<Food> getMockFoods() {
    return [
      Food(
        id: 'f1',
        name: 'Organic Honey',
        imageUrl: 'https://images.openfoodfacts.org/images/products/801/005/301/2490/front_en.8.400.jpg',
        country: 'Spain',
        ingredients: 'Organic honey from wildflowers',
        nutritionGrade: 'a',
      ),
      Food(
        id: 'f2',
        name: 'Dark Chocolate 70%',
        imageUrl: 'https://images.openfoodfacts.org/images/products/300/000/000/5695/front_en.14.400.jpg',
        country: 'Switzerland',
        ingredients: 'Cocoa mass, sugar, cocoa butter, soy lecithin, vanilla extract',
        nutritionGrade: 'c',
      ),
      Food(
        id: 'f3',
        name: 'Olive Oil Extra Virgin',
        imageUrl: 'https://images.openfoodfacts.org/images/products/800/102/807/8426/front_en.4.400.jpg',
        country: 'Italy',
        ingredients: '100% Extra virgin olive oil',
        nutritionGrade: 'a',
      ),
      Food(
        id: 'f4',
        name: 'Greek Yogurt',
        imageUrl: 'https://images.openfoodfacts.org/images/products/501/322/100/0570/front_en.7.400.jpg',
        country: 'Greece',
        ingredients: 'Pasteurized milk, live active cultures',
        nutritionGrade: 'b',
      ),
      Food(
        id: 'f5',
        name: 'Quinoa',
        imageUrl: 'https://images.openfoodfacts.org/images/products/800/022/004/7644/front_en.4.400.jpg',
        country: 'Peru',
        ingredients: '100% Quinoa',
        nutritionGrade: 'a',
      ),
      Food(
        id: 'f6',
        name: 'Atlantic Salmon Fillet',
        imageUrl: 'https://images.openfoodfacts.org/images/products/261/022/003/1799/front_en.3.400.jpg',
        country: 'Norway',
        ingredients: 'Atlantic Salmon (Salmo salar)',
        nutritionGrade: 'a',
      ),
      Food(
        id: 'f7',
        name: 'Organic Almonds',
        imageUrl: 'https://images.openfoodfacts.org/images/products/007/087/406/0616/front_en.3.400.jpg',
        country: 'United States',
        ingredients: 'Organic almonds',
        nutritionGrade: 'a',
      ),
      Food(
        id: 'f8',
        name: 'Whole Grain Bread',
        imageUrl: 'https://images.openfoodfacts.org/images/products/261/022/003/1799/front_en.3.400.jpg',
        country: 'Germany',
        ingredients: 'Whole grain wheat flour, water, yeast, salt',
        nutritionGrade: 'b',
      ),
    ];
  }
}
