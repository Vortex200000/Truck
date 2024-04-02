import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_app/models/index.dart';
import 'package:truck_app/screens/truck_menu_screen.dart';
import 'package:truck_app/screens/widget/truck_item.dart';

class TruckkCard extends StatelessWidget {
  Truck trucks;

  TruckkCard(this.trucks, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TruckMenuScreen(truck: trucks),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 300,
          child: Card(
            color: Colors.white,
            elevation: 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: AssetImage(trucks.thumbnailImageUrl??''),
                            fit: BoxFit.cover)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trucks.truckName,
                        style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Try it now ',
                        style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
