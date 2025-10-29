import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/providers/settings_provider.dart';

class CreateNewPageIconButton extends StatelessWidget {
  final Widget destination;

  const CreateNewPageIconButton({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) => IconButton(
        tooltip: 'create_new_page'.tr(),
        icon: Icon(Icons.edit_outlined),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => destination),
          );
        },
      ),
    );
  }
}
