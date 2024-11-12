import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/app_bar/app_bar_widget.dart';
import 'package:wikinias/bottom_bar/bottom_bar_widget.dart';
import 'package:wikinias/provider/wiki_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WikipediaScreen extends StatefulWidget {
  const WikipediaScreen(
      {super.key});

  @override
  State<WikipediaScreen> createState() => _WikipediaScreenState();
}

class _WikipediaScreenState extends State<WikipediaScreen> {
  late final WebViewController _controller;
  var loadingProgress = 0;

  // Keys
  final GlobalKey wikipediaKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    var initialUrl = 'https://nia.m.wikipedia.org';

    const PlatformWebViewControllerCreationParams params =
    PlatformWebViewControllerCreationParams();

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
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
      ))
      ..loadRequest(
        Uri.parse(initialUrl),
      );

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
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
        // temporary solution for back button when PopScope and WebView together
        if (await _controller.canGoBack()) {
          _controller.goBack();
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('no_back').tr(), duration: const Duration(seconds: 3),)
            );
          }
        }
      },
      child: SafeArea(
        child: Consumer<WikiProvider>(
          builder: (context, wiki, child) => Scaffold(
            key: _scaffoldKey,
            appBar: AppBarWidget(controller: _controller),
            bottomNavigationBar: BottomBarWidget(controller: _controller),
            body: Stack(
              children: [
                WebViewWidget(key: wikipediaKey, controller: _controller),
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
      ),
    );
  }
}
