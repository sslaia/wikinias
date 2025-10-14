import 'package:flutter/material.dart';

class DrawerHeaderContainer extends StatelessWidget {
  const DrawerHeaderContainer({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

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
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}
