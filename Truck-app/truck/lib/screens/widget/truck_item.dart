import 'package:flutter/material.dart';
import 'package:truck_app/models/truck.dart';
import 'package:truck_app/screens/truck_menu_screen.dart';

class TruckItem extends StatefulWidget {
  const TruckItem({
    super.key,
    required this.truck,
  });

  final Truck truck;

  @override
  State<TruckItem> createState() => _TruckItemState();
}

class _TruckItemState extends State<TruckItem> {
  String get _truckName => widget.truck.truckName;

  String? get _truckThumbnailImageUrl => widget.truck.thumbnailImageUrl;

  void _navigateToTruckMenu(Truck truck) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TruckMenuScreen(
          truck: truck,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToTruckMenu(widget.truck),
      child: SizedBox(
        width: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                _truckThumbnailImageUrl!,
                width: 75,
                height: 75,
              ),
              SizedBox.fromSize(
                size: const Size.fromWidth(24),
              ),
              Text(
                _truckName,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.indigoAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
