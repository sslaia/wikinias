import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RefreshHomeIconButton extends StatelessWidget {
  const RefreshHomeIconButton({super.key, required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'refresh'.tr(),
      icon: Icon(Icons.refresh_outlined),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        // Navigate to root route and pop all previous routes
        Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
      },
    );
  }
}