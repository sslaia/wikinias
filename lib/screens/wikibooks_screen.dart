import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikinias/buttons/edit_button.dart';
import 'package:wikinias/buttons/my_back_button.dart';
import 'package:wikinias/buttons/forward_button.dart';
import 'package:wikinias/buttons/random_button.dart';
import 'package:wikinias/buttons/refresh_button.dart';
import 'package:wikinias/buttons/select_language.dart';
import 'package:wikinias/buttons/select_wiki.dart';
import 'package:wikinias/provider/wiki_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:wikinias/buttons/share_button.dart';
import 'package:wikinias/shortcuts/shortcuts_widget.dart';
import 'package:wikinias/buttons/title_button.dart';

class WikibooksScreen extends StatefulWidget {
  const WikibooksScreen(
      {super.key});

  @override
  State<WikibooksScreen> createState() => _WikibooksScreenState();
}

class _WikibooksScreenState extends State<WikibooksScreen> {
  late final WebViewController _controller;
  var loadingProgress = 0;

  // Keys
  final GlobalKey wikibooksKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    var initialUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/Olayama';

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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: wiki.color,
              toolbarHeight: 48.0,
              iconTheme: IconThemeData(
                color: Colors.white, //change your color here
              ),
              title: TitleButton(controller: _controller),
              actions: [
                // Refresh button
                RefreshButton(icon: Icons.replay, tooltip: 'refresh', controller: _controller),
                // Share button
                ShareButton(icon: Icons.share_outlined, label: 'share', controller: _controller),
                // Edit button for editing the wiki page in an external browser
                EditButton(icon: Icons.edit_outlined, label: 'edit', controller: _controller),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              height: 56.0,
              color: wiki.color,
              child: IconTheme(
                data: IconThemeData(
                    color: Theme.of(context).colorScheme.onPrimary),
                child: Row(
                  children: [
                    // Back button
                    MyBackButton(tooltip: 'back', text: 'no_back', controller: _controller),
                    // Forward button
                    ForwardButton(tooltip: 'forward', text: 'no_forward', controller: _controller),
                    Spacer(),
                    // Random page button
                    RandomButton(tooltip: 'random', icon: Icons.shuffle_outlined, controller: _controller),
                    // Shortcuts button
                    IconButton(
                      tooltip: 'shortcuts'.tr(),
                      icon: Icon(Icons.switch_access_shortcut_outlined,
                          color: Colors.white70),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return ShortcutsWidget(controller: _controller);
                          },
                        );
                      },
                    ),
                    //Settings button
                    IconButton(
                      tooltip: 'settings'.tr(),
                      icon: Icon(Icons.more_vert_outlined,
                          color: Colors.white70),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              width: double.infinity,
                              height: 350.0,
                              decoration: const BoxDecoration(
                                  color: Color(0xfffaf6ed),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'select_language',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        // fontWeight: FontWeight.w700,
                                        color: Colors.black54),
                                  ).tr(),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SelectLanguage(
                                        label: 'english',
                                        language: 'en',
                                        backgroundColor: Color(0xff9b00a1),
                                        labelColor: Color(0xff9b00a1),
                                      ),
                                      const SizedBox(width: 16.0),
                                      SelectLanguage(
                                        label: 'nias',
                                        language: 'id',
                                        backgroundColor: Color(0xff121298),
                                        labelColor: Color(0xff121298),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32.0),
                                  Text(
                                    'select_wiki',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        // fontWeight: FontWeight.w700,
                                        color: Colors.black54),
                                  ).tr(),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SelectWiki(
                                          name: 'Wikipedia',
                                          url: 'https://nia.m.wikipedia.org',
                                          backgroundColor: Color(0xff121298),
                                          label: 'wikipedia',
                                          labelColor: Colors.white70),
                                      const SizedBox(width: 8.0),
                                      SelectWiki(
                                          name: 'Wiktionary',
                                          url: 'https://nia.m.wiktionary.org',
                                          backgroundColor: Color(0xffe9d6ae),
                                          label: 'wiktionary',
                                          labelColor: Colors.red),
                                      const SizedBox(width: 8.0),
                                      SelectWiki(
                                          name: 'Wb/nia/Wikibooks',
                                          url: 'https://incubator.m.wikimedia.org',
                                          backgroundColor: Color(0xff9b00a1),
                                          label: 'wikibooks',
                                          labelColor: Colors.white70),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                WebViewWidget(key: wikibooksKey, controller: _controller),
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
