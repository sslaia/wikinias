import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareIconButton extends StatelessWidget {
  const ShareIconButton({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'share'.tr(),
      icon: Icon(Icons.share_outlined),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        SharePlus.instance.share(ShareParams(uri: Uri.parse(url)));
      },
    );
  }
}
