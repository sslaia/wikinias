import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PortalTextButton extends StatelessWidget {
  const PortalTextButton({
    super.key, required this.label, required this.destination,
  });

  final String label;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => destination,
          ),
        );
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ).tr(),
    );
  }
}
