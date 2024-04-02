import 'package:hive/hive.dart';

part 'food_item.g.dart';

@HiveType(typeId: 4)
class FoodItem {
  @HiveField(0)
  final String foodName;
  @HiveField(1)
  final double price;
  @HiveField(2)
  String? truckName;
  @HiveField(3)
  String? photo;

  FoodItem(
      {required this.foodName,
      required this.price,
      this.truckName,
      this.photo});

  @override
  String toString() {
    return 'FoodItem{ foodName: $foodName, price: $price, truckName: $truckName, photo: $photo}';
  }

  FoodItem copyWith({
    String? foodName,
    double? price,
    String? truckName,
    String? photo,
  }) {
    return FoodItem(
        foodName: foodName ?? this.foodName,
        price: price ?? this.price,
        truckName: truckName ?? this.truckName,
        photo: photo ?? this.photo);
  }
}
