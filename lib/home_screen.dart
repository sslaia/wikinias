import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/app_navigation_controls.dart';

class HomeScreen extends StatefulWidget {
  final String url;

  const HomeScreen({
    super.key,
    required this.url,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WebViewController controller;
  var loadingProgress = 0;

  // Keys
  final GlobalKey webviewKey = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    var initialUrl = widget.url;

    controller = WebViewController()
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await controller.canGoBack();
        if (isLastPage) {
          controller.goBack();
          return false;
        } else {
          if (!mounted) return true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.amber,
                content:
                    const Text("no_back", style: TextStyle(color: Colors.black)).tr(),
                duration: const Duration(seconds: 3)),
          );
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          bottomNavigationBar:
              AppNavigationControls(controller: controller),
          body: Stack(
            children: [
              WebViewWidget(key: webviewKey, controller: controller),
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
