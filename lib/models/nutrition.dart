class Nutrition {
  final String foodName;
  final double calories;
  final double totalFat;
  final double protein;
  final double carbs;
  final double fiber;
  final double sugar;
  final String servingUnit;
  final double servingWeight;
  final String imageUrl;

  Nutrition({
    required this.foodName,
    required this.calories,
    required this.totalFat,
    required this.protein,
    required this.carbs,
    required this.fiber,
    required this.sugar,
    required this.servingUnit,
    required this.servingWeight,
    required this.imageUrl,
  });

  // Mock data factory
  static List<Nutrition> getMockNutritionData() {
    return [
      Nutrition(
        foodName: 'egg',
        calories: 78.0,
        totalFat: 5.3,
        protein: 6.3,
        carbs: 0.6,
        fiber: 0.0,
        sugar: 0.6,
        servingUnit: 'large',
        servingWeight: 50.0,
        imageUrl: 'https://nix-tag-images.s3.amazonaws.com/542_thumb.jpg',
      ),
      Nutrition(
        foodName: 'bacon',
        calories: 43.0,
        totalFat: 3.3,
        protein: 3.0,
        carbs: 0.1,
        fiber: 0.0,
        sugar: 0.0,
        servingUnit: 'slice',
        servingWeight: 8.5,
        imageUrl: 'https://nix-tag-images.s3.amazonaws.com/735_thumb.jpg',
      ),
      Nutrition(
        foodName: 'avocado',
        calories: 240.0,
        totalFat: 22.0,
        protein: 3.0,
        carbs: 12.0,
        fiber: 10.0,
        sugar: 1.0,
        servingUnit: 'fruit',
        servingWeight: 150.0,
        imageUrl: 'https://nix-tag-images.s3.amazonaws.com/384_thumb.jpg',
      ),
      Nutrition(
        foodName: 'chicken breast',
        calories: 165.0,
        totalFat: 3.6,
        protein: 31.0,
        carbs: 0.0,
        fiber: 0.0,
        sugar: 0.0,
        servingUnit: 'piece',
        servingWeight: 100.0,
        imageUrl: 'https://nix-tag-images.s3.amazonaws.com/1007_thumb.jpg',
      ),
      Nutrition(
        foodName: 'sweet potato',
        calories: 112.0,
        totalFat: 0.1,
        protein: 2.0,
        carbs: 26.0,
        fiber: 3.0,
        sugar: 5.4,
        servingUnit: 'medium',
        servingWeight: 130.0,
        imageUrl: 'https://nix-tag-images.s3.amazonaws.com/1427_thumb.jpg',
      ),
    ];
  }
}
