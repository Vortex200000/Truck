// ignore: file_names
import 'package:flutter/material.dart'
    show
        AssetImage,
        Border,
        BorderRadius,
        BoxDecoration,
        BoxFit,
        BuildContext,
        Colors,
        Container,
        DecorationImage,
        EdgeInsets,
        MediaQuery,
        Padding,
        StatelessWidget,
        Widget;

class ImageSlider extends StatelessWidget {
  final String imageBath;

  const ImageSlider(this.imageBath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.transparent),
            image: DecorationImage(
                image: AssetImage(imageBath.toString()), fit: BoxFit.cover)),
      ),
    );
  }
}
