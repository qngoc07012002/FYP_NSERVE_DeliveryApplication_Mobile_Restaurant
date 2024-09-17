// lib/models/food_item.dart
class FoodItem {
  String name;
  String imageUrl;
  String? description;
  bool isAvailable;

  FoodItem(this.name, this.imageUrl, this.description, this.isAvailable);

  @override
  String toString() {
    return 'FoodItem(name: $name, imageUrl: $imageUrl, description: $description, isAvailable: $isAvailable)';
  }
}
