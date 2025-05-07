/// Represents nutritional information for a food item
/// This class serves as the Model in the MVVM architecture
class Nutrition {
  /// Name of the food item
  final String foodName;
  
  /// Calories per serving
  final double calories;
  
  /// Total fat in grams per serving
  final double totalFat;
  
  /// Protein in grams per serving
  final double protein;
  
  /// Carbohydrates in grams per serving
  final double carbs;
  
  /// Fiber in grams per serving
  final double fiber;
  
  /// Sugar in grams per serving
  final double sugar;
  
  /// Unit of serving (e.g., cup, tablespoon, piece)
  final String servingUnit;
  
  /// Weight of the serving in grams
  final double servingWeight;
  
  /// URL to the food item image
  final String imageUrl;

  /// Constructor for creating a Nutrition object
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

  /// Factory method to create a Nutrition object from JSON data
  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      foodName: json['food_name'] ?? '',
      calories: (json['nf_calories'] ?? 0.0).toDouble(),
      totalFat: (json['nf_total_fat'] ?? 0.0).toDouble(),
      protein: (json['nf_protein'] ?? 0.0).toDouble(),
      carbs: (json['nf_total_carbohydrate'] ?? 0.0).toDouble(),
      fiber: (json['nf_dietary_fiber'] ?? 0.0).toDouble(),
      sugar: (json['nf_sugars'] ?? 0.0).toDouble(),
      servingUnit: json['serving_unit'] ?? '',
      servingWeight: (json['serving_weight_grams'] ?? 0.0).toDouble(),
      imageUrl: json['photo']?['thumb'] ?? '',
    );
  }

  /// Convert Nutrition object to JSON
  Map<String, dynamic> toJson() {
    return {
      'food_name': foodName,
      'nf_calories': calories,
      'nf_total_fat': totalFat,
      'nf_protein': protein,
      'nf_total_carbohydrate': carbs,
      'nf_dietary_fiber': fiber,
      'nf_sugars': sugar,
      'serving_unit': servingUnit,
      'serving_weight_grams': servingWeight,
      'photo': {'thumb': imageUrl},
    };
  }

  /// Create a copy of this Nutrition with modified properties
  Nutrition copyWith({
    String? foodName,
    double? calories,
    double? totalFat,
    double? protein,
    double? carbs,
    double? fiber,
    double? sugar,
    String? servingUnit,
    double? servingWeight,
    String? imageUrl,
  }) {
    return Nutrition(
      foodName: foodName ?? this.foodName,
      calories: calories ?? this.calories,
      totalFat: totalFat ?? this.totalFat,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      servingUnit: servingUnit ?? this.servingUnit,
      servingWeight: servingWeight ?? this.servingWeight,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Generate mock nutrition data for testing and development
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
