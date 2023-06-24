import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/app_navigation_controls.dart';
import 'package:wikinias/wiki_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WebViewController webViewController;
  var loadingProgress = 0;

  // Keys
  final GlobalKey webviewKey = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Wiki variables
  String wikiProject = '';
  String wikiHome = '';
  String wikiColor = '';

  @override
  void initState() {
    super.initState();

    wikiProject = Provider.of<WikiProvider>(context, listen: false).project;
    if (wikiProject == 'Wikibooks') {
      setState(() {
        wikiHome = 'https://incubator.wikimedia.org/wiki/Wb/nia/Olayama';
        wikiColor = '0xff9b00a1';
      });
    } else if (wikiProject == 'Wiktionary') {
      setState(() {
        wikiHome = 'https://nia.wiktionary.org';
        wikiColor = '0xfffaf6ed';
      });
    } else {
      setState(() {
        wikiHome = 'https://nia.wikipedia.org';
        wikiColor = '0xff121298';
      });
    }

    webViewController = WebViewController()
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
        Uri.parse(wikiHome),
      );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await webViewController.canGoBack();
        if (isLastPage) {
          webViewController.goBack();
          return false;
        } else {
          if (!mounted) return true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.amber,
                content:
                    const Text("no_back", style: TextStyle(color: Colors.black))
                        .tr(),
                duration: const Duration(seconds: 3)),
          );
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: media.height > 768
              ? AppBar(
                  backgroundColor: Color(int.parse(wikiColor)),
                  title: Text(
                    'wikinias_slogan2',
                    style: GoogleFonts.grandstander(
                      textStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          // fontStyle: FontStyle.italic,
                          color: Colors.white),
                    ),
                  ).tr(),
                )
              : null,
          bottomNavigationBar:
              AppNavigationControls(webViewController: webViewController),
          body: Stack(
            children: [
              WebViewWidget(key: webviewKey, controller: webViewController),
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
