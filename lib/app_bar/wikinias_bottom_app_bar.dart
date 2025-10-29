import 'package:flutter/material.dart';

class WikiniasBottomAppBar extends StatelessWidget {
  final List<Widget> children;

  const WikiniasBottomAppBar({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: children,
      ),
    );
  }
}