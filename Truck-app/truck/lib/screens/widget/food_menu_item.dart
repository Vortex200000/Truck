import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/models/index.dart';

typedef OnResetCart = Function(OrderItem item, int index);

class FoodMenuItem extends StatefulWidget {
  const FoodMenuItem({
    super.key,
    required this.foodItem,
    required this.index,
    this.isSummary = false,
    this.onResetCart,
  });

  factory FoodMenuItem.summary({
    required OrderItem orderItem,
    required int index,
    OnResetCart? onResetCart,
  }) {
    return FoodMenuItem(
      foodItem: orderItem,
      index: index,
      isSummary: true,
      onResetCart: onResetCart,
    );
  }

  final bool isSummary;
  final int index;
  final FoodItem foodItem;
  final OnResetCart? onResetCart;

  @override
  State<FoodMenuItem> createState() => _FoodMenuItemState();
}

class _FoodMenuItemState extends State<FoodMenuItem> {
  FoodItem get _food => widget.foodItem;
  late OrderItem _orderItem;

  late int _count;

  @override
  void initState() {
    _orderItem = OrderItem.fromFoodItem(_food);
    if (widget.isSummary) {
      _orderItem = widget.foodItem as OrderItem;
    }
    try {
      final OrderItem currentOrderItem = HiveClient()
          .cartBox
          .values
          .cast<OrderItem>()
          .firstWhere((element) => _orderItem.foodName == element.foodName);
      _count = currentOrderItem.count;
    } catch (e) {
      _count = _orderItem.count;
    }
    super.initState();
  }

  void _decrementItemCount() {
    setState(() {
      _count--;
    });
    if (_count == 0) {
      _removeItemFromCart();
    } else {
      OrderItem updatedItem = _orderItem.copyWith(count: _count);

      HiveClient().cartBox.put(widget.index, updatedItem);
    }
  }

  void _removeItemFromCart() {
    HiveClient().cartBox.deleteAt(widget.index);
  }

  void _handleDifferentTruck() async {
    try {
      final bool isExistingCart =
          HiveClient().currentCartTruckBox.values.isNotEmpty;
      if (isExistingCart) {
        final OrderItem existingTruckName =
            await HiveClient().currentCartTruckBox.getAt(0);
        if (_orderItem.truckName != existingTruckName.truckName) {
          widget.onResetCart?.call(_orderItem, widget.index);
        }
      } else {
        HiveClient().currentCartTruckBox.put(0, _orderItem);
      }
    } catch (e) {
      log('handleDifferentTruck ${e.toString()}');
    }
  }

  Future<void> _incrementItemCount() async {
    _handleDifferentTruck();
    setState(() {
      _count++;
    });
    final updatedItem = _orderItem.copyWith(count: _count);
    await HiveClient().cartBox.put(widget.index, updatedItem);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Todo: add food.png
            Image.asset(
              'assets/download.jpeg',
              width: 75,
              height: 75,
            ),
            SizedBox.fromSize(
              size: const Size.fromWidth(24),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _food.foodName,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.indigoAccent,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'EGP ${_food.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.indigoAccent,
                        ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Visibility(
                  visible: !widget.isSummary,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _count >= 1 ? _decrementItemCount : null,
                  ),
                ),
                Text('$_count'),
                Visibility(
                  visible: !widget.isSummary,
                  child: IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: _incrementItemCount,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
