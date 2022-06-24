import 'dart:async';
import 'dart:io' as IO;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wikinias/about.dart';
import 'package:wikinias/drawer.dart';
import 'package:wikinias/provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WikiHome extends StatefulWidget {
  const WikiHome({Key? key}) : super(key: key);

  @override
  WikiHomeState createState() => WikiHomeState();
}

class WikiHomeState extends State<WikiHome> {
  // Controllers
  WebViewController? webviewController;
  final Completer<WebViewController> completerController =
      Completer<WebViewController>();
  // Keys
  final webviewKey = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // BottomAppBar icon color
  Color iconColor = Colors.white; // bottomappbar icon color
  Color bgColor = const Color(0xff121298);
  // Progress bar
  double progress = 0; // for showing the progress bar

  @override
  void initState() {
    if (IO.Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: SafeArea(
        child: Consumer<WikiProvider>(
          builder: (context, wiki, child) => Scaffold(
            key: scaffoldKey,
            drawer: WikiDrawer(
              controller: completerController,
              url: wiki.url,
              project: wiki.project,
            ),
            bottomNavigationBar: BottomAppBar(
              color: bgColor,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // open the menu drawer
                        scaffoldKey.currentState?.openDrawer();
                      });
                    },
                    icon: Icon(Icons.menu, color: iconColor),
                  ),
                  const SizedBox(width: 12.0),
                  TextButton(
                    onPressed: () {
                      webviewController?.loadUrl('${wiki.url}Olayama');
                    },
                    child: Text(
                      'wikiNias',
                      style: GoogleFonts.cinzelDecorative(
                        textStyle: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      bgColor = const Color(0xff121298);
                      webviewController?.loadUrl('https://nia.m.wikipedia.org/wiki/Olayama');
                      wiki.setWiki('Wikipedia');
                    },
                    icon: Image.asset('assets/icons/action_wp.png'),
                    tooltip: 'Wikipedia',
                  ),
                  IconButton(
                    onPressed: () {
                      bgColor = const Color(0xffe9d6ae);
                      webviewController?.loadUrl('https://nia.m.wiktionary.org/wiki/Olayama');
                      wiki.setWiki('Wiktionary');
                    },
                    icon: Image.asset('assets/icons/action_wt.png'),
                    tooltip: 'Wiktionary',
                  ),
                  IconButton(
                    onPressed: () {
                      bgColor = const Color(0xff9b00a1);
                      webviewController?.loadUrl('https://incubator.m.wikimedia.org/wiki/Wb/nia/Olayama');
                      wiki.setWiki('Wikibooks');
                    },
                    icon: Image.asset('assets/icons/action_wb.png'),
                    tooltip: 'Wikibuku',
                  ),
                  IconButton(
                    onPressed: () {
                      // to show settings menu using RelativeReact for position
                      showMenu(
                          context: context,
                          position: const RelativeRect.fromLTRB(
                              1000.0, 1000.0, 0.0, 0.0),
                          items: <PopupMenuItem<String>>[
                            PopupMenuItem<String>(
                              child: ListTile(
                                leading: const Icon(Icons.language_outlined,
                                    color: Colors.purple),
                                title: const Text('about').tr(),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AboutWikiNias(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            PopupMenuItem<String>(
                              child: ListTile(
                                leading: const Icon(Icons.language_outlined,
                                    color: Colors.purple),
                                title: const Text('English'),
                                onTap: () {
                                  setState(() {
                                    context.setLocale(const Locale('en'));
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            PopupMenuItem<String>(
                              child: ListTile(
                                leading: const Icon(Icons.language_outlined,
                                    color: Colors.indigo),
                                title: const Text('Li Niha'),
                                onTap: () {
                                  setState(() {
                                    context.setLocale(const Locale('id'));
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            PopupMenuItem<String>(
                              child: ListTile(
                                leading: const Icon(Icons.shuffle,
                                    color: Colors.black54),
                                title: const Text('random').tr(),
                                onTap: () {
                                  webviewController
                                      ?.loadUrl('${wiki.url}Special:Random');
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            PopupMenuItem<String>(
                              child: ListTile(
                                leading: const Icon(Icons.refresh,
                                    color: Colors.black54),
                                title: const Text('refresh').tr(),
                                onTap: () {
                                  webviewController?.reload();
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ]);
                    },
                    icon: Icon(Icons.more_vert, color: iconColor),
                  ),
                ],
              ),
            ),
            body: Column(
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        color: bgColor,
                        backgroundColor: Colors.white54,
                      ),
                      Expanded(
                        child: WebView(
                            key: webviewKey,
                            initialUrl: '${wiki.url}Olayama',
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated: (WebViewController controller) {
                              completerController.future
                                  .then((value) => webviewController = value);
                              completerController.complete(controller);
                            },
                            onProgress: (progress) =>
                                this.progress = progress / 100),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop(BuildContext context) async {
    var status = await webviewController!.canGoBack();
    if (!status) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("no_back").tr(),
          duration: const Duration(seconds: 3),
        ),
      );
      return false;
    } else {
      webviewController!.goBack();
      return false;
    }
  }
}
