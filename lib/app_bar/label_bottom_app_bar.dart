import 'package:flutter/material.dart';

import 'bottom_app_bar_label_button.dart';

// The sole purpose of this widget is to add a bottom app bar with certain label.
class LabelBottomAppBar extends StatelessWidget {
  const LabelBottomAppBar({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          BottomAppBarLabelButton(label: label.toLowerCase()),
          const Spacer(),
        ],
      ),
    );
  }
}
