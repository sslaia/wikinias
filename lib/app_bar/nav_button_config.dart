import 'package:flutter/material.dart';

// wikinias_bottom_app_bar.dart needs this class

class NavButtonConfig {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed; // Here is the callback!

  NavButtonConfig({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });
}
