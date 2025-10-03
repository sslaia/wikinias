import 'package:flutter/material.dart';

class MainHeaderImage extends StatelessWidget {
  const MainHeaderImage({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.fitHeight,
          )),
    );
  }
}
