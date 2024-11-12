import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/app_bar/edit_button.dart';
import 'package:wikinias/app_bar/share_button.dart';
import 'package:wikinias/app_bar/title_button.dart';
import 'package:wikinias/provider/wiki_provider.dart';
import 'package:wikinias/app_bar/settings_button.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required WebViewController controller,
  }) : _controller = controller;

  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: wiki.color,
        toolbarHeight: 48.0,
        iconTheme: IconThemeData(
          color: (wiki.name == 'Wiktionary') ? Colors.black87 : Colors.white70, //change your color here
        ),
        title: TitleButton(controller: _controller),
        actions: [
          // Edit button for editing the wiki page in an external browser
          EditButton(icon: Icons.edit_outlined, label: 'edit', controller: _controller),
          // Share button
          ShareButton(icon: Icons.share_outlined, label: 'share', controller: _controller),
          // Settings button
          SettingsButton(controller: _controller),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
