import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WikiDrawer extends StatelessWidget {
  final Completer<WebViewController> _controller;
  final String url;
  final String project;

  const WikiDrawer({
    Key? key,
    required Completer<WebViewController> controller,
    required this.url,
    required this.project,
  })   : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return Container(
              // color: color,
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage('assets/images/book.webp')),
                    ),
                    child: Stack(children: [
                      Positioned(
                        bottom: 12.0,
                        left: 12.0,
                        child: Text(
                          project,
                          style: GoogleFonts.cinzelDecorative(
                              textStyle: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                    ]),
                  ),
                  ListTile(
                      leading: const Icon(Icons.local_fire_department_outlined),
                      title: Text("recent_changes").tr(),
                      onTap: () {
                        Navigator.pop(context);
                        controller.data!.loadUrl('${url}Special:RecentChanges');
                      }),
                  ListTile(
                      leading: const Icon(Icons.security_outlined),
                      title: Text("special_pages").tr(),
                      onTap: () {
                        Navigator.pop(context);
                        controller.data!.loadUrl('${url}Special:SpecialPages');
                      }),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text('announcement').tr(),
                    onTap: () {
                      Navigator.pop(context);
                      controller.data!.loadUrl('$url$project:Angombakhata');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.meeting_room_outlined),
                    title: Text('community_portal').tr(),
                    onTap: () {
                      Navigator.pop(context);
                      controller.data!.loadUrl('$url$project:Bawagöli_zato');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bubble_chart_outlined),
                    title: Text('village_pump').tr(),
                    onTap: () {
                      Navigator.pop(context);
                      controller.data!.loadUrl('$url$project:Monganga_afo');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.gesture_outlined),
                    title: Text('sandbox').tr(),
                    onTap: () {
                      Navigator.pop(context);
                      controller.data!.loadUrl('$url$project:Nahia_wamakori');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.handyman_outlined),
                    title: Text('help').tr(),
                    onTap: () {
                      Navigator.pop(context);
                      controller.data!.loadUrl('$url$project:Fanolo');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people_outlined),
                    title: Text('helpers').tr(),
                    onTap: () {
                      Navigator.pop(context);
                      controller.data!.loadUrl('$url$project:Sangai_halöŵö');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.local_florist_outlined),
                    title: Text('about').tr(),
                    onTap: () {
                      Navigator.pop(context);
                      controller.data!.loadUrl('$url$project:Sanandrösa');
                    },
                  ),
                ],
              ),
            );
          }
          return Container(
            child: const Text('Can\'t get the data'),
          );
        },
      ),
    );
  }
}