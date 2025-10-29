import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:wikinias/widgets/create_new_page_form.dart';

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
    final String wikibukuUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
    final String wikibukuForm = 'preload=Template:Wb/nia/Famörögö wanura';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
          title: Text('search_results'.tr(), style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          )),
          actions: [
            CreateNewPageIconButton(destination: CreateNewPageForm(url: wikibukuUrl, form: wikibukuForm)),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
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
