import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RefreshIconButton extends StatelessWidget {
  const RefreshIconButton({
    super.key,
    required this.color,
    required this.destination,
  });

  final Color color;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'refresh'.tr(),
      icon: Icon(Icons.refresh_outlined),
      color: color,
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => destination,
          ),
        );
      },
    );
  }
}
