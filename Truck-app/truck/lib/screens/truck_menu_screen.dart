import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/models/index.dart';
import 'package:truck_app/screens/cart_screen.dart';

import 'widget/food_menu_item.dart';

class TruckMenuScreen extends StatefulWidget {
  const TruckMenuScreen({
    super.key,
    required this.truck,
  });

  final Truck truck;

  @override
  State<TruckMenuScreen> createState() => _TruckMenuScreenState();
}

class _TruckMenuScreenState extends State<TruckMenuScreen> {
  late List<FoodItem> _foodItemList;

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;

  @override
  void initState() {
    _foodItemList = widget.truck.foodList?.toList() ?? [];
    super.initState();
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }

  Future<void> _resetCart(OrderItem item, int index) async {
    Navigator.of(context).maybePop();
    await HiveClient().currentCartTruckBox.put(0, item);
    await HiveClient().cartBox.clear();
    await HiveClient().cartBox.put(index, item.copyWith(count: 1));
    setState(() {});
  }

  Future<void> _showEmptyCartPopup(OrderItem item, int index) async {
    AlertDialog alert = AlertDialog(
      title: const Text('Empty Cart?'),
      content: const Text(
          'This will empty your cart before adding an item from a different truck.'),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _resetCart(item, index),
          child: const Text('Clear'),
        ),
      ],
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => alert,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.truck.truckName),
        backgroundColor: Colors.white,
        actions: [
          // IconButton(
          //   onPressed: _navigateToCart,
          //   icon: const Icon(
          //     Icons.shopping_cart_rounded,
          //     color: Colors.blueAccent,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  _navigateToCart();
                },
                child: SvgPicture.asset(
                  'assets/SvgIcons/cart-5-svgrepo-com.svg',
                  width: 40,
                  height: 40,
                )),
          )
        ],
      ),
      body: ListView.separated(
        itemCount: _foodItemList.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) => SizedBox(
          height: 100,
          child: FoodMenuItem(
            foodItem: _foodItemList[index],
            index: index,
            onResetCart: _showEmptyCartPopup,
          ),
        ),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
