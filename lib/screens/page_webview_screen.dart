import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class PageWebviewScreen extends StatefulWidget {
  const PageWebviewScreen({
    super.key,
    required this.title,
    required this.url,
    required this.color,
  });

  final String title;
  final String url;
  final Color color;

  @override
  State<PageWebviewScreen> createState() =>
      _PageWebviewScreenState();
}

class _PageWebviewScreenState
    extends State<PageWebviewScreen> {
  late final WebViewController _controller;
  var loadingProgress = 0;

  // Keys
  final GlobalKey _webViewKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // var initialUrl = 'https://nia.m.wikipedia.org/wiki/Olayama';
    var initialUrl = widget.url.replaceAll(' ', '%20');

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        // to do
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: widget.color,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
              title: Text(
                widget.title,
                style: TextStyle(
                  color: widget.color,
                ),
              )),
          body: Stack(
            children: [
              WebViewWidget(key: _webViewKey, controller: _controller),
              if (loadingProgress < 100)
                LinearProgressIndicator(
                  backgroundColor: Colors.amber,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  value: loadingProgress / 100.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
