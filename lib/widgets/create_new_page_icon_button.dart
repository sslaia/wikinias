import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreateNewPageIconButton extends StatelessWidget {
  const CreateNewPageIconButton({
    super.key,
    required this.label,
    required this.destination,
    required this.color
  });

  final String label;
  final Widget destination;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'create_new_page'.tr(),
      icon: Icon(Icons.edit_outlined),
      color: color,
      onPressed: () {
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