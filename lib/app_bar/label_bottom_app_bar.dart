import 'package:flutter/material.dart';

import 'bottom_app_bar_text_button.dart';

// The sole purpose of this widget is to add a bottom app bar with certain label.
class LabelBottomAppBar extends StatelessWidget {
  const LabelBottomAppBar({super.key, required this.label, required this.color, required this.destination});

  final String label;
  final Color color;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          BottomAppBarTextButton(label: label, color: color, destination: destination),
          const Spacer(),
        ],
      ),
    );
  }
}
