import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/home_portals.dart';
import 'package:wikimedia_core/wikimedia_core.dart';
import '../providers/app_state.dart';
import '../utils/wiki_utils.dart';

class WikiPortalsWidget extends ConsumerWidget {
  final ProjectType project;
  final String languageCode;

  const WikiPortalsWidget({
    super.key,
    required this.project,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final portalsData = HomePortals.getPortals(context);
    final projectStr = project.name.toLowerCase();

    final projectPortals = portalsData[languageCode]?[projectStr] ?? [];

    if (projectPortals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'wiki_portals'.tr(),
            style: GoogleFonts.montserratAlternates(
              textStyle: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Container(
          height: 140,
          margin: const EdgeInsets.only(bottom: 24),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: projectPortals.length,
            itemBuilder: (context, index) {
              final portal = projectPortals[index];
              return _buildPortalCard(context, ref, theme, portal);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPortalCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    Map<String, dynamic> portal,
  ) {
    final title = portal['title'] as String;
    final label = (portal['label'] as String).tr();

    final currentProject = ref.watch(appStateProvider);
    final langCode = context.locale.languageCode;

    return GestureDetector(
      onTap: () => WikiUtils.handleTapUrl(context, './$title', null, currentProject, langCode),
      child: Container(
        width: 140,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: project.primaryColor.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: project.primaryColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getPortalIcon(portal['label'] as String),
                color: project.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPortalIcon(String labelKey) {
    switch (labelKey) {
      case "portal_animals":
        return Icons.pets_rounded;
      case "portal_business":
        return Icons.business_rounded;
      case "portal_german":
        return Icons.flag_rounded;
      case "portal_english":
        return Icons.flag_rounded;
      case "portal_health":
        return Icons.health_and_safety_rounded;
      case "portal_custom":
        return Icons.people_rounded;
      case "portal_indonesian":
        return Icons.flag_rounded;
      case "portal_colours":
        return Icons.colorize_rounded;
      case "portal_anatomy":
        return Icons.boy_rounded;
      case "portal_nias":
        return Icons.flag_rounded;
      case "portal_plants":
        return Icons.grass_rounded;
      case 'portal_transport':
        return Icons.car_rental_rounded;
      case 'portal_proverbs':
        return Icons.format_quote_rounded;
      case 'portal_short_stories':
        return Icons.auto_stories_rounded;
      case 'portal_recipes':
        return Icons.restaurant_rounded;
      case 'portal_fairy_tales':
        return Icons.menu_book_rounded;
      case 'portal_folksongs':
        return Icons.music_note_rounded;
      case 'portal_speeches':
        return Icons.record_voice_over_rounded;
      case 'portal_dictionary':
        return Icons.translate_rounded;
      case 'portal_dances':
        return Icons.accessibility_new_rounded;
      case 'portal_stories':
        return Icons.menu_book_rounded;
      case 'portal_novel':
        return Icons.book_rounded;
      case 'portal_nias_pop':
        return Icons.audiotrack_rounded;
      case 'portal_bible':
        return Icons.import_contacts_rounded;
      case 'portal_biography':
        return Icons.person_rounded;
      case 'portal_geography':
        return Icons.public_rounded;
      case 'portal_chemistry':
        return Icons.science_rounded;
      case 'portal_community':
        return Icons.groups_rounded;
      case 'portal_science':
        return Icons.biotech_rounded;
      case 'portal_history':
        return Icons.history_edu_rounded;
      case 'portal_arts':
        return Icons.palette_rounded;
      case 'portal_technology':
        return Icons.memory_rounded;
      case 'portal_religion':
        return Icons.account_balance_rounded;
      case 'portal_biology':
        return Icons.eco_rounded;
      case 'portal_government':
        return Icons.gavel_rounded;
      case 'portal_culture':
        return Icons.theater_comedy_rounded;
      case 'portal_maths':
        return Icons.functions_rounded;
      case 'portal_media':
        return Icons.movie_rounded;
      case 'portal_wikijunior':
        return Icons.child_care_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }
}
