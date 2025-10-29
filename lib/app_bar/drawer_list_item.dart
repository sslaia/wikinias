import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DrawerListItem extends StatelessWidget {
  final String text;
  final Icon icon;
  final Widget? destination;

  const DrawerListItem({
    super.key,
    required this.text,
    required this.icon,
    this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: icon,
      title: Text(text.tr(), style: Theme.of(context).textTheme.titleMedium),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => destination!),
        );
      },
    );
  }
}
