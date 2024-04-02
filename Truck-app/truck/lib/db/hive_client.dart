import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:truck_app/models/index.dart';

class HiveClient {
  static final HiveClient _instance = HiveClient._();

  late final Box currentUserBox;
  late final Box currentCartTruckBox;
  late final Box userBox;
  late final Box truckBox;
  late final Box foodBox;
  late final Box orderBox;
  late final Box cartBox;

  factory HiveClient() {
    return _instance;
  }

  HiveClient._();

  Future<void> init() async {
    final Directory directory =
        await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(TruckAdapter());
    Hive.registerAdapter(FoodItemAdapter());
    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(OrderItemAdapter());

    currentUserBox = await Hive.openBox<User>(HiveConstants.currentUserBoxKey);
    currentCartTruckBox =
        await Hive.openBox<OrderItem>(HiveConstants.currentCartTruckBox);
    userBox = await Hive.openBox<User>(HiveConstants.userBoxKey);
    foodBox = await Hive.openBox<FoodItem>(HiveConstants.foodBoxKey);
    truckBox = await Hive.openBox<Truck>(HiveConstants.truckBoxKey);
    orderBox = await Hive.openBox<Order>(HiveConstants.orderBoxKey);
    cartBox = await Hive.openBox<OrderItem>(HiveConstants.cartBoxKey);
    _addMenusToBoxes();
  }

  void _addMenusToBoxes() {
    // Create food items for Pharaoh's Falafel Wagon
    final List<FoodItem> pharaohsFalafelFoodList = [
      FoodItem(
          foodName: 'Classic Falafel Wrap',
          price: 5.99,
          photo: 'assets/chicken-shawarma-gyros-9.jpg',
          truckName: 'Pharaoh\'s Falafel Wagon'),
      FoodItem(
          foodName: 'Falafel Platter',
          price: 7.99,
          photo: 'assets/chicken-shawarma-gyros-9.jpg',
          truckName: 'Pharaoh\'s Falafel Wagon'),
      FoodItem(
          foodName: 'Falafel Sandwich',
          photo: 'assets/chicken-shawarma-gyros-9.jpg',
          price: 4.99,
          truckName: 'Pharaoh\'s Falafel Wagon'),
    ];

// Create food items for Nile Street Shawarma Shuttle
    final List<FoodItem> nileStreetShawarmaFoodList = [
      FoodItem(
          foodName: 'Chicken Shawarma Wrap',
          price: 6.99,
          truckName: 'Nile Street Shawarma Shuttle'),
      FoodItem(
          foodName: 'Beef Shawarma Platter',
          price: 8.99,
          truckName: 'Nile Street Shawarma Shuttle'),
      FoodItem(
          foodName: 'Lamb Shawarma Sandwich',
          price: 7.99,
          truckName: 'Nile Street Shawarma Shuttle'),
    ];

// Create food items for Cairo Koshary Cart
    final List<FoodItem> cairoKosharyFoodList = [
      FoodItem(
          foodName: 'Traditional Koshary Bowl',
          price: 6.49,
          truckName: 'Cairo Koshary Cart'),
      FoodItem(
          foodName: 'Spicy Koshary Platter',
          price: 7.99,
          truckName: 'Cairo Koshary Cart'),
      FoodItem(
          foodName: 'Koshary Salad',
          price: 5.99,
          truckName: 'Cairo Koshary Cart'),
    ];

    final List<FoodItem> burgerFoodList = [
      FoodItem(
          foodName: 'Meat Burger ', price: 6.49, truckName: 'Cairo Truck Cart'),
      FoodItem(
          foodName: 'Chicken Burger ',
          price: 7.99,
          truckName: 'Burger Truck Cart'),
      FoodItem(
          foodName: 'Mixed Burger',
          price: 5.99,
          truckName: 'Burger Truck Cart'),
    ];

    // Create and add Pharaoh's Falafel Wagon truck
    final Truck pharaohsFalafelTruck = Truck(
        truckName: 'Pharaoh\'s Falafel Wagon',
        foodList: pharaohsFalafelFoodList,
        thumbnailImageUrl: 'assets/Falafel-TIMG.jpg');
    for (var element in pharaohsFalafelFoodList) {
      element.truckName = pharaohsFalafelTruck.truckName;
    }

    // Create and add Nile Street Shawarma Shuttle truck
    final Truck nileStreetShawarmaTruck = Truck(
      truckName: 'Nile Street Shawarma Shuttle',
      foodList: nileStreetShawarmaFoodList,
      thumbnailImageUrl: 'assets/chicken-shawarma-gyros-9.jpg',
    );
    for (var element in nileStreetShawarmaFoodList) {
      element.truckName = nileStreetShawarmaTruck.truckName;
    }

    // Create and add Cairo Koshary Cart truck
    final Truck cairoKosharyTruck = Truck(
        truckName: 'Cairo Koshary Cart',
        foodList: cairoKosharyFoodList,
        thumbnailImageUrl: 'assets/egyptian_koshary_800x800.jpg');

    final Truck burgerTruck = Truck(
        truckName: 'Kings Of Burger',
        foodList: burgerFoodList,
        thumbnailImageUrl: 'assets/download.jpeg');
    for (var element in pharaohsFalafelFoodList) {
      element.truckName = pharaohsFalafelTruck.truckName;
    }

    // Adds the trucks to the db, if the db is not empty
    if (truckBox.isEmpty) {
      // truckBox.clear();
      truckBox.add(pharaohsFalafelTruck);
      truckBox.add(nileStreetShawarmaTruck);
      truckBox.add(cairoKosharyTruck);
      truckBox.add(burgerTruck);
    }

    // Adds the food to the db, if the db is not empty
    if (!foodBox.isEmpty) {
      foodBox.clear();
      //
      // foodBox.addAll(pharaohsFalafelFoodList);
      // foodBox.addAll(nileStreetShawarmaFoodList);
      // foodBox.addAll(cairoKosharyFoodList);
      // foodBox.addAll(burgerFoodList);
    }
  }
}

class HiveConstants {
  HiveConstants._();

  static const String userBoxKey = 'userBoxKey';
  static const String truckBoxKey = 'truckBoxKey';
  static const String foodBoxKey = 'foodBoxKey';
  static const String orderBoxKey = 'orderBoxKey';
  static const String currentUserBoxKey = 'currentUserBoxKey';
  static const String currentCartTruckBox = 'currentCartTruckBoxKey';
  static const String cartBoxKey = 'cartBoxKey';
}
