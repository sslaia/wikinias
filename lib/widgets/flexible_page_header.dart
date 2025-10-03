import 'package:flutter/material.dart';

class FlexiblePageHeader extends StatelessWidget {
  const FlexiblePageHeader({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                image,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                height: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
