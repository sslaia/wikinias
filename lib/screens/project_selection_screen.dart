import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/spacer_color_bar.dart';

class ProjectSelectionScreen extends StatelessWidget {
  const ProjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                // App name
                Text(
                  'WikiNias',
                  style: TextStyle(
                    fontFamily: 'CinzelDecorative',
                    fontSize: 34.0,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 30),
                // Project selection header
                Text(
                  'select_wiki',
                  style: TextStyle(color: color),
                ).tr(),
                const SizedBox(height: 16.0),
                // Project selection items
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        settingsProvider.selectedProject = Project.Niaspedia;
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff121298),
                      ),
                      child: Text(
                        'niaspedia',
                        style: TextStyle(
                          fontFamily: 'CinzelDecorative',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ).tr(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        settingsProvider.selectedProject = Project.Wikibuku;
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/wikibuku');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff9b00a1),
                      ),
                      child: Text(
                        'wikibuku',
                        style: TextStyle(
                          fontFamily: 'CinzelDecorative',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ).tr(),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        settingsProvider.selectedProject = Project.Wikikamus;
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/wikikamus');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffe9d6ae),
                      ),
                      child: Text(
                        'wikikamus',
                        style: TextStyle(
                          fontFamily: 'CinzelDecorative',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ).tr(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        settingsProvider.selectedProject = Project.Courses;
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/courses');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff121298),
                      ),
                      child: Text(
                        'courses',
                        style: TextStyle(
                          fontFamily: 'CinzelDecorative',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ).tr(),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        settingsProvider.selectedProject = Project.Gallery;
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/gallery');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff9b00a1),
                      ),
                      child: Text(
                        'gallery',
                        style: TextStyle(
                          fontFamily: 'CinzelDecorative',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ).tr(),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SpacerColorBar(imageWidth: 250),
                const SizedBox(height: 70.0),
                // Language selection header
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'settings_message',
                    style: TextStyle(color: color),
                    textAlign: TextAlign.center,
                  ).tr(),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
