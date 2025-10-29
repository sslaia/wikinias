import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewOnWebIconButton extends StatelessWidget {
  const ViewOnWebIconButton({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'view_on_the_web'.tr(),
      icon: Icon(Icons.visibility_outlined),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        launchUrl(Uri.parse(url));
        },
    );
  }
}
