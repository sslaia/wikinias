import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ShortcutsIconButton extends StatelessWidget {
  const ShortcutsIconButton({
    super.key,
    required this.shortcuts,
    required this.color,
  });

  final Widget shortcuts;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'shortcuts'.tr(),
      icon: Icon(Icons.switch_access_shortcut_outlined),
      color: color,
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return shortcuts;
          },
        );
      },
    );
  }
}
