import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_type.dart';
import '../screens/create_book_screen.dart';
import '../screens/create_entry_screen.dart';
import '../screens/create_page_screen.dart';

class ContributeWidget extends StatelessWidget {
  final ProjectType project;

  const ContributeWidget({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: project.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: project.primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: project.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: project.primaryColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'contribute'.tr(),
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzelDecorative(
              textStyle: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: project.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'contribute_description'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Widget destination;
              switch (project) {
                case ProjectType.wikipedia:
                  destination = const CreatePageScreen();
                  break;
                case ProjectType.wiktionary:
                  destination = const CreateEntryScreen();
                  break;
                case ProjectType.wikibooks:
                  destination = const CreateBookScreen();
                  break;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => destination),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: project.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              'get_started'.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
