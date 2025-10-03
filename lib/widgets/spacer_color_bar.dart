import 'package:flutter/material.dart';

class SpacerColorBar extends StatelessWidget {
  final double imageWidth;
  const SpacerColorBar({super.key, required this.imageWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      width: imageWidth,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/color_bar.webp"),
            fit: BoxFit.fitWidth,
          )),
    );
  }
}
