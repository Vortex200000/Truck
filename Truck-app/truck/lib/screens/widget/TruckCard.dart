// ignore: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_app/models/index.dart';
import 'package:truck_app/screens/truck_menu_screen.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
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
          ),
        );
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
                            image: AssetImage(trucks.thumbnailImageUrl ?? ''),
                            fit: BoxFit.cover)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trucks.truckName,
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Try it now ',
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          child: IconButton(
                            iconSize: 20,
                            icon: const Icon(Icons.location_on_outlined),
                            onPressed: () async {
                              await goToWebPage(
                                  "https://www.google.com/maps/@29.9100485,30.9470419,17z?entry=ttu");
                            },
                          ),
                        ),
                      )
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

  Future<void> goToWebPage(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'could not launch $url';
    }
  }
}
