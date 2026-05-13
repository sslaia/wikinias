import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/project_type.dart';
import '../screens/article_screen.dart';

class ShortcutUtils {
  static IconData getIconData(String name) {
    switch (name) {
      case 'campaign_outlined':
        return Icons.campaign_rounded;
      case 'chat_bubble_outlined':
        return Icons.chat_bubble_rounded;
      case 'construction_outlined':
        return Icons.construction_rounded;
      case 'help_outlined':
      case 'help_outline':
        return Icons.help_outline_rounded;
      case 'history':
        return Icons.history_rounded;
      case 'newspaper_outlined':
        return Icons.newspaper_rounded;
      case 'pages_outlined':
        return Icons.pages_rounded;
      case 'people_outlined':
      case 'people_outline':
        return Icons.people_rounded;
      case 'support_agent_outlined':
        return Icons.support_agent_rounded;
      case 'water_drop_outlined':
        return Icons.water_drop_rounded;
      case 'content_copy':
        return Icons.content_copy_rounded;
      default:
        return Icons.shortcut_rounded;
    }
  }

  static Future<void> handleShortcutTap(
    BuildContext context,
    String pageTitle,
    String langCode,
    ProjectType project,
  ) async {
    bool isSpecialPage = false;
    if (pageTitle.isNotEmpty) {
      final lowerTitle = pageTitle.toLowerCase();
      isSpecialPage =
          lowerTitle.startsWith('special:') ||
          lowerTitle.startsWith('spesial:') ||
          lowerTitle.startsWith('mirunggan:') ||
          lowerTitle.startsWith('istimewa:') ||
          lowerTitle.startsWith('istimiwa:') ||
          lowerTitle.startsWith('istimèwa:') ||
          lowerTitle.startsWith('khas:') ||
          lowerTitle.startsWith('husus:');
    }

    if (isSpecialPage || pageTitle.isEmpty) {
      String url;
      if (langCode == 'nia' && project == ProjectType.wikibooks) {
        url = 'https://incubator.wikimedia.org/wiki/$pageTitle';
      } else {
        url =
            'https://$langCode.${project.name.toLowerCase()}.org/wiki/$pageTitle';
      }

      final uri = Uri.parse(url);
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
        }
      } catch (e) {
        debugPrint('Could not launch $url: $e');
      }
    } else {
      // TEMP: Strip Nias Wikibooks prefix for cleaner display title
      String displayTitle = pageTitle;
      if (displayTitle.startsWith('Wb/nia/')) {
        displayTitle = displayTitle.replaceFirst('Wb/nia/', '');
      }

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ArticleScreen(title: displayTitle)),
        );
      }
    }
  }
}
