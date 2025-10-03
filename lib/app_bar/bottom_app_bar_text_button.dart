import 'package:flutter/material.dart';

class BottomAppBarTextButton extends StatelessWidget {
  const BottomAppBarTextButton({super.key, required this.label, required this.color, required this.destination});

  final String label;
  final Color color;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => destination,
          ),
        );
      },
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'CinzelDecorative',
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
