import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DrawerListItem extends StatelessWidget {
  final String text;
  final Icon icon;
  final Widget destination;
  const DrawerListItem({
    super.key,
    required this.text,
    required this.icon,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final double bodyFontSize =
        Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return ListTile(
      leading: icon,
      title: Text(text, style: TextStyle(fontSize: bodyFontSize)).tr(),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => destination),
        );
      },
    );
  }
}
