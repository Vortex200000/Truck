// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/models/index.dart';
import 'package:truck_app/screens/truck_screen.dart';
import 'package:truck_app/screens/widget/food_menu_item.dart';

class CartScreen extends StatefulWidget {
  CartScreen({
    required this.truck,
    super.key,
  });

  Truck truck;

  @override
  // ignore: no_logic_in_create_state
  State<CartScreen> createState() => _CartScreenState(truck);
}

class _CartScreenState extends State<CartScreen> {
  late List<OrderItem> _orderItems;
  Truck truck;

  _CartScreenState(this.truck);

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;
  double total = 0;
  late bool isCartEmpty;

  @override
  void initState() {
    _orderItems = HiveClient().cartBox.values.toList().cast<OrderItem>();
    _orderItems.forEach(_calculateTotal);
    isCartEmpty = HiveClient().cartBox.isEmpty;
    log('cartBox: ${HiveClient().cartBox.values.toList()}');
    super.initState();
  }

  void _calculateTotal(e) => total += e.price * e.count;

  Future<void> _resetCart(OrderItem item) async {
    Navigator.of(context).maybePop();
    await HiveClient().currentCartTruckBox.put(0, item);
    await HiveClient().cartBox.clear();
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
          onPressed: () => _resetCart(item),
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

  Future<void> _submitOrder() async {
    final User user = await HiveClient().userBox.values.first as User;
    Order order = Order(
        userId: user.email,
        items: _orderItems,
        dateTimeStamp: DateTime.now().millisecondsSinceEpoch);
    await HiveClient().orderBox.add(order);
    await HiveClient().cartBox.clear();
    _showOrderSuccessfulDialog();
  }

  void _showOrderSuccessfulDialog() {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Order Successful'),
      content: Column(children: [
        Text('Price : $total'),
        const SizedBox(
          height: 10,
        ),
        Text('Truck : ${widget.truck.truckName}'),
        const SizedBox(
          height: 20,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Name'),
            Text('Price'),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_orderItems.first.foodName),
            Text(_orderItems.first.price.toString()),
          ],
        )
      ]),
      actions: [
        ElevatedButton(
          onPressed: _dismissAndNavigateToTrucks,
          child: const Text('Ok'),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  void _dismissAndNavigateToTrucks() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const TruckScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trucks"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            isCartEmpty
                ? Center(
                    child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            'assets/SvgIcons/empty-cart-svgrepo-com.svg'),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Sorry Your Cart Is Empty',
                          style:
                              GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ))
                : const SizedBox.shrink(),
            isCartEmpty
                ? Center(
                    child: Text('Please add Items',
                        style:
                            GoogleFonts.aBeeZee(fontWeight: FontWeight.bold)),
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: ListView.separated(
                itemCount: _orderItems.length,
                itemBuilder: (context, index) => SizedBox(
                  height: 100,
                  child: FoodMenuItem.summary(
                    photo: widget.truck.thumbnailImageUrl ?? '',
                    orderItem: _orderItems[index],
                    index: index,
                    onResetCart: _showEmptyCartPopup,
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
            Visibility(
              visible: !isCartEmpty,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Total:',
                          style: GoogleFonts.aBeeZee(color: Colors.black),
                        ),
                        Text('EGP ${total.toStringAsFixed(2)}',
                            style: GoogleFonts.aBeeZee(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Visibility(
              visible: !isCartEmpty,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6652cc),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: _submitOrder,
                      child: Text(
                        'Submit Order',
                        style: GoogleFonts.aBeeZee(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
