import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RefreshHomeIconButton extends StatelessWidget {
  const RefreshHomeIconButton({super.key, required this.color, required this.route});

  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'refresh'.tr(),
      icon: Icon(Icons.refresh_outlined),
      color: color,
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}