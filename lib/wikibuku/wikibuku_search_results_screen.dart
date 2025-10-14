import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../providers/settings_provider.dart';
import '../widgets/create_new_page_form.dart';
import '../widgets/create_new_page_icon_button.dart';

class WikibukuSearchResultsScreen extends StatefulWidget {
  final String query;

  const WikibukuSearchResultsScreen({super.key, required this.query});

  @override
  State<WikibukuSearchResultsScreen> createState() =>
      _WikibukuSearchResultsScreenState();
}

class _WikibukuSearchResultsScreenState
    extends State<WikibukuSearchResultsScreen> {
  late final WebViewController _controller;
  var loadingProgress = 0;

  // Keys
  final GlobalKey wikiKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    var initialUrl =
        'https://incubator.m.wikimedia.org/w/index.php?search=${widget.query}&title=Special%3ASearch&ns0=1&prefix=Wb/nia';

    const PlatformWebViewControllerCreationParams params =
        PlatformWebViewControllerCreationParams();

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingProgress = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingProgress = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingProgress = 100;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
      (controller.platform as AndroidWebViewController).setTextZoom(125);
    }
    _controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;
    final double bodyFontSize =
        Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          title: Text('search_results', style: TextStyle(color: color, fontSize: bodyFontSize * 1.0)).tr(),
          actions: [
            Consumer<SettingsProvider>(
              builder: (context, settingsProvider, child) =>
                  CreateNewPageIconButton(
                    label: 'create_new_page',
                    destination: CreateNewPageForm(url: settingsProvider.getProjectUrl()),
                    color: color,
                  ),
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(key: wikiKey, controller: _controller),
            if (loadingProgress < 100)
              LinearProgressIndicator(
                backgroundColor: Colors.amber,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                value: loadingProgress / 100.0,
              ),
          ],
        ),
      ),
    );
  }
}
