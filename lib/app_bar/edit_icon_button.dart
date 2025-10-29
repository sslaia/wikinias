import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EditIconButton extends StatelessWidget {
  const EditIconButton({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'edit'.tr(),
      icon: Icon(Icons.edit_outlined),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        launchUrl(Uri.parse('$url?action=edit&section=all'));
      },
    );
  }
}
