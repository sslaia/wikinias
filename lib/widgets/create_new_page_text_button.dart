import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreateNewPageTextButton extends StatelessWidget {
  const CreateNewPageTextButton({
    super.key,
    required this.label,
    required this.destination,
  });
  final String label;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => destination),
        );
      },
      child: Text(
        label.tr(),
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
