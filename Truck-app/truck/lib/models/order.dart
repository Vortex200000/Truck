import 'package:hive/hive.dart';
import 'package:truck_app/models/index.dart';

part 'order.g.dart';


@HiveType(typeId: 3)
class Order extends HiveObject {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final List<OrderItem> items;
  @HiveField(2)
  final int? dateTimeStamp;

  bool get isOrdered => dateTimeStamp != null;

  Order({
    required this.userId,
    required this.items,
    this.dateTimeStamp,
  });

  //<editor-fold desc="Data Methods">

  @override
  String toString() {
    return 'Order{ userId: $userId, items: $items, dateTimeStamp: $dateTimeStamp, isOrdered: $isOrdered }';
  }

  Order copyWith({
    String? userId,
    List<OrderItem>? items,
    int? dateTimeStamp,
  }) {
    return Order(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      dateTimeStamp: dateTimeStamp ?? this.dateTimeStamp,
    );
  }
}
