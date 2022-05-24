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
  _WikiHomeState createState() => _WikiHomeState();
}

class _WikiHomeState extends State<WikiHome> {
  WebViewController? controller;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  // String? booksUrl;
  final _webviewKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String wbUrl = 'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
  final String wpUrl = 'https://nia.m.wikipedia.org/wiki/';
  final String wtUrl = 'https://nia.m.wiktionary.org/wiki/';
  final wbcolor = Colors.purple[50];
  final wpcolor = Colors.indigo[50];
  final wtcolor = Colors.orange[50];

  String project = 'Wikipedia';
  String baseUrl = 'https://nia.m.wikipedia.org/wiki/';
  Color? bColor = const Color(0xff121298);
  Color? iColor = Colors.white;
  double progress = 0; // for showing the progress bar

  bool hasInternet = false;
  final SnackBar _noInternet = SnackBar(
    content: const Text('no_internet').tr(),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.red,
  );

  @override
  void initState() {
    if (IO.Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _checkInternet();
    super.initState();
  }

  void _checkInternet() async {
    // check internet connection first
    hasInternet = await InternetConnectionChecker().hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WikiProvider>(
      builder: (context, wikiNotifier, child) => WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            drawer: WikiDrawer(
              controller: _controller,
              // color: bColor,
              url: baseUrl,
              project: project,
              // title: widget.title
            ),
            bottomNavigationBar: BottomAppBar(
              // key: _scaffoldKey,
              color: bColor,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // open the menu drawer
                        _scaffoldKey.currentState?.openDrawer();
                      });
                    },
                    icon: Icon(Icons.menu, color: iColor),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    'Wiki Nias',
                    style: GoogleFonts.cinzelDecorative(
                      textStyle: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      hasInternet =
                      await InternetConnectionChecker().hasConnection;
                      // reload the initial page
                      hasInternet
                          ? controller?.loadUrl('${wpUrl}Olayama')
                          : ScaffoldMessenger.of(context)
                          .showSnackBar(_noInternet);
                      setState(() {
                        baseUrl = 'https://nia.m.wikipedia.org/wiki/';
                        project = 'Wikipedia';
                        bColor = const Color(0xff121298);
                      });
                    },
                    icon: Image.asset('assets/icons/action_wp.png'),
                    tooltip: 'Wikipedia',
                  ),
                  IconButton(
                    onPressed: () async {
                      // reload the initial page
                      hasInternet =
                      await InternetConnectionChecker().hasConnection;
                      hasInternet
                          ? controller?.loadUrl('${wtUrl}Olayama')
                          : ScaffoldMessenger.of(context)
                          .showSnackBar(_noInternet);
                      setState(() {
                        baseUrl = 'https://nia.m.wiktionary.org/wiki/';
                        project = 'Wiktionary';
                        bColor = const Color(0xffe9d6ae);
                      });
                    },
                    icon: Image.asset('assets/icons/action_wt.png'),
                    tooltip: 'Wiktionary',
                  ),
                  IconButton(
                    onPressed: () async {
                      // reload the initial page
                      hasInternet =
                      await InternetConnectionChecker().hasConnection;
                      hasInternet
                          ? controller?.loadUrl('${wbUrl}Olayama')
                          : ScaffoldMessenger.of(context)
                          .showSnackBar(_noInternet);
                      setState(() {
                        baseUrl =
                        'https://incubator.m.wikimedia.org/wiki/Wb/nia/';
                        project = 'Wikibooks';
                        bColor = const Color(0xff9b00a1);
                      });
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
                                      builder: (context) => const AboutWikiNias(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            PopupMenuItem<String>(
                              child: ListTile(
                                leading: const Icon(Icons.language_outlined,
                                    color: Colors.purple),
                                title: const Text('In English'),
                                onTap: () {
                                  setState(() {
                                    context.setLocale(const Locale('en'));
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ),
                            PopupMenuItem<String>(
                              child: ListTile(
                                leading: const Icon(Icons.language_outlined,
                                    color: Colors.indigo),
                                title: const Text('Ba Li Niha'),
                                onTap: () {
                                  setState(() {
                                    context.setLocale(const Locale('id'));
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ),
                            PopupMenuItem<String>(
                              // value: 'english',
                              child: ListTile(
                                leading: const Icon(Icons.shuffle,
                                    color: Colors.black54),
                                title: const Text('random').tr(),
                                onTap: () {
                                  controller
                                      ?.loadUrl('${baseUrl}Special:Random');
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ),
                            PopupMenuItem<String>(
                              // value: 'english',
                              child: ListTile(
                                leading: const Icon(Icons.refresh,
                                    color: Colors.black54),
                                title: const Text('refresh').tr(),
                                onTap: () {
                                  controller?.reload();
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ),
                          ]);
                    },
                    icon: Icon(Icons.more_vert, color: iColor),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  color: bColor,
                  backgroundColor: Colors.white54,
                ),
                Expanded(
                  child: WebView(
                      key: _webviewKey,
                      initialUrl: '${baseUrl}Olayama',
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.future.then((value) => controller = value);
                        _controller.complete(webViewController);
                      },
                      onProgress: (progress) => this.progress = progress / 100),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    var status = await controller!.canGoBack();
    if (status) {
      controller!.goBack();
      return false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              "no_back").tr(),
          duration: const Duration(seconds: 3),
        ),
      );
      return false;
    }
  }
}