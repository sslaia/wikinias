import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikinias/wiki_provider.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  // Controllers
  final TextEditingController textEditingController = TextEditingController();
  final Completer<WebViewController> completerController =
      Completer<WebViewController>();
  WebViewController? webviewController;

  // Keys
  final GlobalKey webviewKey = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // hiding webview when bottomsheet expands
  bool bottomSheetToggle = false;

  // media query
  bool isMobile = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (width < 412 && height < 915) {
      isMobile = true;
    } else if (width < 915 && height < 412) {
      isMobile = true;
    } else {
      isMobile = false;
    }

    return WillPopScope(
      onWillPop: () async {
        var status = await webviewController!.canGoBack();
        if (status) {
          webviewController!.goBack();
          // return false;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.indigoAccent,
                content: const Text("no_back").tr(),
                duration: const Duration(seconds: 3)),
          );
          // return false;
        }
        return false;
      },
      child: SafeArea(
        child: Consumer<WikiProvider>(
          builder: (context, wiki, child) => Scaffold(
            appBar: isMobile ? null : buildAppBar(wiki),
            bottomNavigationBar: buildBottomAppBar(wiki),
            body: buildAppBody(wiki),
          ),
        ),
      ),
    );
  }

  Column buildAppBody(WikiProvider wiki) {
    return Column(
      children: [
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
          ),
        ),
        // only show if bottomsheet expands
        bottomSheetToggle
            ? Container(
                height: 255,
                color: Color(int.parse(wiki.color.split('(0x')[1].split(')')[0],
                    radix: 16)))
            : const SizedBox(height: 0),
      ],
    );
  }

  buildAppBar(WikiProvider wiki) {
    return AppBar(
      elevation: 8.0,
      backgroundColor:
          Color(int.parse(wiki.color.split('(0x')[1].split(')')[0], radix: 16)),
      automaticallyImplyLeading: false,
      title: Text(
        wiki.project,
        style: GoogleFonts.cinzelDecorative(
          textStyle: const TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.settings_outlined),
      //     onPressed: () {
      //       // shrink webview when bottomsheet expands
      //       setState(() => bottomSheetToggle = true);
      //       // show bottomsheet (settings)
      //       showSettingsDialog(wiki, webviewController!);
      //     },
      //   ),
      // ],
    );
  }

  BottomAppBar buildBottomAppBar(WikiProvider wiki) {
    return BottomAppBar(
      color: Color(int.parse(wiki.color.split('(0x')[1].split(')')[0],
          radix: 16)), // background color
      child: Row(
        children: [
          const SizedBox(width: 12.0),
          Text(
            'WikiNias',
            style: GoogleFonts.cinzelDecorative(
              textStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Load the main page
              webviewController!.loadUrl('${wiki.url}Olayama');
            },
            icon: const Icon(Icons.home_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              // Load a random page
              webviewController!.loadUrl('${wiki.url}Special:Random');
            },
            icon: const Icon(Icons.shuffle_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              // Reload the page
              webviewController!.reload();
            },
            icon: const Icon(Icons.refresh_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              // shrink webview when bottomsheet expands
              setState(() => bottomSheetToggle = true);
              // show bottomsheet (shortcuts)
              showShortcutsDialog(wiki, webviewController!);
            },
            icon: const Icon(Icons.switch_access_shortcut_outlined,
                color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              // shrink webview when bottomsheet expands
              setState(() => bottomSheetToggle = true);
              // show bottomsheet (settings)
              showSettingsDialog(wiki, webviewController!);
            },
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }

  showSettingsDialog(WikiProvider wiki, WebViewController webViewController) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            // boxShadow: [BoxShadow(
            //   color: Colors.white30,
            //   spreadRadius: 5,
            //   blurRadius: 7,
            //   offset: const Offset(0, 3),
            // )],
          ),
          height: 300.0,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'choose_language',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
              ).tr(),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      context.setLocale(const Locale('en'));
                      Navigator.pop(context);
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff9b00a1)))),
                    ),
                    // style: ButtonStyle(
                    //     backgroundColor:
                    //         MaterialStateProperty.all(const Color(0xff9b00a1))),
                    child: const Text(
                      'English',
                      style: TextStyle(
                        color: Color(0xff9b00a1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50.0),
                  TextButton(
                    onPressed: () {
                      context.setLocale(const Locale('id'));
                      Navigator.pop(context);
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff121298)))),
                    ),
                    child: const Text(
                      'Li Niha',
                      style: TextStyle(
                        color: Color(0xff121298),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              Text(
                'choose_wiki_project',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
              ).tr(),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController
                          ?.loadUrl('https://nia.m.wikipedia.org/wiki/Olayama');
                      wiki.setWiki('Wikipedia');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff121298)))),
                    ),
                    child: const Text(
                      'Wikipedia',
                      style: TextStyle(
                        color: Color(0xff121298),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32.0),
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController?.loadUrl(
                          'https://nia.m.wiktionary.org/wiki/Olayama');
                      wiki.setWiki('Wiktionary');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xffe9d6ae)))),
                    ),
                    child: const Text(
                      'Wiktionary',
                      style: TextStyle(
                        color: Color(0xffe9d6ae),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32.0),
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController?.loadUrl(
                          'https://incubator.m.wikimedia.org/wiki/Wb/nia/Olayama');
                      wiki.setWiki('Wikibooks');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff9b00a1)))),
                    ),
                    child: const Text(
                      'Wikibooks',
                      style: TextStyle(
                        color: Color(0xff9b00a1),
                        // color: Color(0xff9b00a1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  showShortcutsDialog(WikiProvider wiki, WebViewController webViewController) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          // color: Colors.amberAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('shortcuts',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w700))
                  .tr(),
              const SizedBox(height: 20.0),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                children: [
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController!
                          .loadUrl('${wiki.url}Special:RecentChanges');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff121298)))),
                    ),
                    child: const Text(
                      'recent_changes',
                      style: TextStyle(
                        color: Color(0xff121298),
                      ),
                    ).tr(),
                  ),
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController!
                          .loadUrl('${wiki.url}Special:SpecialPages');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff9b00a1)))),
                    ),
                    child: const Text(
                      'special_pages',
                      style: TextStyle(
                        color: Color(0xff9b00a1),
                      ),
                    ).tr(),
                  ),
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController!
                          .loadUrl('${wiki.url}${wiki.project}:Angombakhata');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff121298)))),
                    ),
                    child: const Text(
                      'announcement',
                      style: TextStyle(
                        color: Color(0xff121298),
                      ),
                    ).tr(),
                  ),
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController!
                          .loadUrl('${wiki.url}${wiki.project}:Bawagöli_zato');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff9b00a1)))),
                    ),
                    child: const Text(
                      'community_portal',
                      style: TextStyle(
                        color: Color(0xff9b00a1),
                      ),
                    ).tr(),
                  ),
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController!
                          .loadUrl('${wiki.url}${wiki.project}:Monganga_afo');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff121298)))),
                    ),
                    child: const Text(
                      'village_pump',
                      style: TextStyle(
                        color: Color(0xff121298),
                      ),
                    ).tr(),
                  ),
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController!
                          .loadUrl('${wiki.url}${wiki.project}:Nahia_wamakori');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff9b00a1)))),
                    ),
                    child: const Text(
                      'sandbox',
                      style: TextStyle(
                        color: Color(0xff9b00a1),
                      ),
                    ).tr(),
                  ),
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController!
                          .loadUrl('${wiki.url}${wiki.project}:Fanolo');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff121298)))),
                    ),
                    child: const Text(
                      'help',
                      style: TextStyle(
                        color: Color(0xff121298),
                      ),
                    ).tr(),
                  ),
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController!
                          .loadUrl('${wiki.url}${wiki.project}:Sangai_halöŵö');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff9b00a1)))),
                    ),
                    child: const Text(
                      'helpers',
                      style: TextStyle(
                        color: Color(0xff9b00a1),
                      ),
                    ).tr(),
                  ),
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController!.loadUrl(
                          'https://nia.m.wikipedia.org/wiki/Wikipedia:Fafa wanura Nias');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff9b00a1)))),
                    ),
                    child: const Text(
                      'nias_keyboard',
                      style: TextStyle(
                        color: Color(0xff9b00a1),
                      ),
                    ).tr(),
                  ),
                  TextButton(
                    onPressed: () {
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController!
                          .loadUrl('${wiki.url}${wiki.project}:Sanandrösa');
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff121298)))),
                    ),
                    child: const Text(
                      'about_wiki',
                      style: TextStyle(
                        color: Color(0xff121298),
                      ),
                    ).tr(),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // expand the webview when bottomsheet shrinks
                      setState(() => bottomSheetToggle = false);
                      // load the webview
                      webviewController!
                          .loadUrl('https://wikinias.blogspot.com');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff9b00a1)))),
                    ),
                    child: const Text(
                      'about_wikinias_app',
                      style: TextStyle(
                        color: Color(0xff9b00a1),
                      ),
                    ).tr(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
