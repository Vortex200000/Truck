// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/models/index.dart';
import 'package:truck_app/screens/login_screen.dart';
import 'package:truck_app/screens/widget/TruckCard.dart';
import 'package:truck_app/screens/widget/truck_item.dart';

class TruckScreen extends StatefulWidget {
  const TruckScreen({super.key});

  @override
  State<TruckScreen> createState() => _TruckScreenState();
}

class _TruckScreenState extends State<TruckScreen> {
  late final List<Truck> _trucksList;

  @override
  void initState() {
    _trucksList = HiveClient().truckBox.values.toList().cast<Truck>();
    super.initState();
  }

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;

  void _logoutUser() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        // title: const Text("Trucks"),
        backgroundColor: Colors.white,
        actions: [
          Row(
            children: [
              Text(
                'Log Out',
                style: GoogleFonts.aBeeZee(),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _logoutUser,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Availaple Food ',
                  //   style: GoogleFonts.aBeeZee(
                  //       fontWeight: FontWeight.bold, fontSize: 25),
                  // ),
                  Text(
                    'Trucks',
                    style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 700,
              child: ListView.builder(
                  itemCount: _trucksList.length,
                  padding: const EdgeInsets.all(12),
                  physics: PageScrollPhysics(),
                  itemBuilder: (context, index) =>
                      TruckkCard(_trucksList[index])),
            ),
          ],
        ),
      ),
    );
  }
}
