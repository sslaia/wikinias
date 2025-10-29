import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RefreshIconButton extends StatelessWidget {
  const RefreshIconButton({super.key, required this.destination});

  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'refresh'.tr(),
      icon: Icon(Icons.refresh_outlined),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (context) => destination,
          ),
        );
      },
    );
  }
}
