import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeIconButton extends StatelessWidget {
  const HomeIconButton({
    super.key,
    required this.color, required this.route,
  });

  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'home'.tr(),
      icon: Icon(Icons.home_outlined),
      color: color,
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}