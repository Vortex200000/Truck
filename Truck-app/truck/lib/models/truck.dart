import 'package:hive/hive.dart';
import 'package:truck_app/models/index.dart';

part 'truck.g.dart';

@HiveType(typeId: 1)
class Truck extends HiveObject {
  @HiveField(0)
  final String truckName;
  @HiveField(1)
  final String? thumbnailImageUrl;
  @HiveField(2)
  List<FoodItem>? foodList;

  //<editor-fold desc="Data Methods">
  Truck({
    required this.truckName,
    this.thumbnailImageUrl,
    this.foodList,
  });

  @override
  String toString() {
    return 'Truck{ truckName: $truckName, thumbnailImageUrl: $thumbnailImageUrl, foodList: $foodList }';
  }

  Truck copyWith({
    String? truckName,
    String? thumbnailImageUrl,
  }) {
    return Truck(
      truckName: truckName ?? this.truckName,
      thumbnailImageUrl: thumbnailImageUrl ?? this.thumbnailImageUrl,
    );
  }

//</editor-fold>
}
