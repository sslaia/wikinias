import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/bottom_bar/forward_button.dart';
import 'package:wikinias/bottom_bar/my_back_button.dart';
import 'package:wikinias/bottom_bar/random_button.dart';
import 'package:wikinias/bottom_bar/refresh_button.dart';
import 'package:wikinias/bottom_bar/shortcuts_button.dart';
import 'package:wikinias/provider/wiki_provider.dart';

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({
    super.key,
    required WebViewController controller,
  }) : _controller = controller;

  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wiki, child) => BottomAppBar(
        height: 56.0,
        color: wiki.color,
        child: IconTheme(
          data: IconThemeData(
              color: (wiki.name == 'Wiktionary') ? Colors.black87 : Colors.white70),
          child: Row(
            children: [
              // Back button
              MyBackButton(tooltip: 'back', text: 'no_back', controller: _controller),
              // Forward button
              ForwardButton(tooltip: 'forward', text: 'no_forward', controller: _controller),
              Spacer(),
              // Refresh button
              RefreshButton(icon: Icons.replay, tooltip: 'refresh', controller: _controller),
              // Random page button
              RandomButton(tooltip: 'random', icon: Icons.shuffle_outlined, controller: _controller),
              // Shortcuts button
              ShortcutsButton(controller: _controller),
              //Settings button
              // SettingsButtonBottom(controller: _controller),
            ],
          ),
        ),
      ),
    );
  }
}
