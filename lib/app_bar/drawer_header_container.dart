import 'package:flutter/material.dart';

class DrawerHeaderContainer extends StatelessWidget {
  const DrawerHeaderContainer({
    super.key,
    required this.image,
    required this.color,
  });

  final String image;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          'WikiNias',
          style: TextStyle(
            fontFamily: 'CinzelDecorative',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}
