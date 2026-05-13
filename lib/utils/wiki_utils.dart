import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../models/project_type.dart';
import '../providers/history_provider.dart';
import '../screens/article_screen.dart';
import '../screens/create_page_screen.dart';
import '../screens/create_entry_screen.dart';
import '../screens/create_book_screen.dart';
import '../theme/app_theme.dart';

class WikiUtils {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static bool isIcon(String src) {
    final lowerSrc = src.toLowerCase();
    return lowerSrc.contains('/static/images/mobile/copyright/') ||
        lowerSrc.contains('/static/images/footer/') ||
        lowerSrc.contains('.svg') ||
        lowerSrc.contains('px-gnome-') ||
        lowerSrc.contains('px-icon-') ||
        lowerSrc.contains('px-symbol_') ||
        lowerSrc.contains('px-help-') ||
        lowerSrc.contains('px-information_') ||
        lowerSrc.contains('px-ambox_') ||
        lowerSrc.contains('px-question_mark') ||
        lowerSrc.contains('px-edit-clear') ||
        lowerSrc.contains('px-magnifying_glass') ||
        lowerSrc.contains('px-search_icon') ||
        lowerSrc.contains('px-crystal_clear') ||
        lowerSrc.contains('px-c_icon') ||
        lowerSrc.contains('px-system-') ||
        lowerSrc.contains('px-padlock-');
  }

  static String optimizeImageUrl(
    String url, {
    String? langCode,
    String? projectStr,
    int width = 600,
  }) {
    String normalized = url;

    if (url.startsWith('//')) {
      normalized = 'https:$url';
    } else if (url.startsWith('/') && langCode != null && projectStr != null) {
      /// Temporary solution while Nias Wikibooks is still in the Incubator
      if (langCode == 'nia' && projectStr == 'wikibooks') {
        normalized = 'https://incubator.wikimedia.org$url';
      } else {
        normalized = 'https://$langCode.$projectStr.org$url';
      }
    } else if (!url.startsWith('http') && !url.startsWith('/')) {
      normalized = 'https:$url';
    }

    /// Convert thumbnail to high resolution
    if (normalized.contains('/thumb/')) {
      final regExp = RegExp(r'\/(\d+)px-');
      if (regExp.hasMatch(normalized)) {
        return normalized.replaceFirst(regExp, '/${width}px-');
      }
    }
    return normalized;
  }

  static bool handleTapUrl(
    BuildContext context,
    String url,
    String? htmlContent,
    ProjectType currentProject,
  ) {
    debugPrint('WikiUtils: handling URL: $url');

    if (url.startsWith('#') || url.contains('cite_note')) {
      if (htmlContent != null) {
        final refId = url.split('#').last;
        _showReferencePopup(context, refId, htmlContent);
      }
      return true;
    }

    String? title;
    bool isRedLink = url.contains('action=edit') || url.contains('redlink=1');

    if (url.contains('/wiki/')) {
      title = url.split('/wiki/').last.split('?').first.split('#').first;
    } else if (url.startsWith('./')) {
      title = url.substring(2).split('?').first.split('#').first;
    } else if (url.contains('title=') && url.contains('/w/index.php')) {
      try {
        final uri = Uri.parse(url);
        title = uri.queryParameters['title'];
      } catch (_) {
        final match = RegExp(r'title=([^&]+)').firstMatch(url);
        title = match?.group(1);
      }
    } else if (!url.contains(':') &&
        !url.contains('/') &&
        url.isNotEmpty &&
        !url.startsWith('http')) {
      title = url.split('?').first.split('#').first;
    }

    if (title != null) {
      String decodedTitle;
      try {
        decodedTitle = Uri.decodeComponent(title).replaceAll('_', ' ');
      } catch (e) {
        decodedTitle = title.replaceAll('_', ' ');
      }

      /// Temporary solution: Nias Wikibooks prefix from taps for cleaner navigation
      if (decodedTitle.contains('Wb/nia/')) {
        decodedTitle = decodedTitle.replaceFirst('Wb/nia/', '');
      }

      if (decodedTitle.isNotEmpty) {
        /// Register this title in the history stack before navigating
        final container = ProviderScope.containerOf(context);
        container.read(historyProvider.notifier).push(decodedTitle);

        if (isRedLink) {
          Widget screen;
          switch (currentProject) {
            case ProjectType.wiktionary:
              screen = CreateEntryScreen(title: decodedTitle);
              break;
            case ProjectType.wikibooks:
              screen = CreateBookScreen(title: decodedTitle);
              break;
            case ProjectType.wikipedia:
            screen = CreatePageScreen(initialTitle: decodedTitle);
              break;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => screen,
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArticleScreen(title: decodedTitle),
            ),
          );
        }
        return true;
      }
    }

    /// Handle Audio links directly
    final lowerUrl = url.toLowerCase();
    final audioExtensions = ['.mp3', '.ogg', '.wav', '.m4a'];
    if (audioExtensions.any(
          (ext) => lowerUrl.endsWith(ext) || lowerUrl.contains('$ext?'),
        ) ||
        (lowerUrl.contains('upload.wikimedia.org') &&
            audioExtensions.any((ext) => lowerUrl.contains(ext)))) {
      _playAudio(context, url);
      return true;
    }

    if (url.startsWith('http')) {
      _launchExternalUrl(url);
      return true;
    }

    return false;
  }

  static Future<void> _launchExternalUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    }
  }

  static Future<void> _playAudio(BuildContext context, String url) async {
    String audioUrl = url;
    if (url.startsWith('//')) {
      audioUrl = 'https:$url';
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Text('Playing audio...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      await _audioPlayer.stop();
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('WikiUtils: Error playing audio: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not play audio')));
      }
    }
  }

  static Map<String, String>? customStyles(
    BuildContext context,
    dom.Element element,
  ) {
    final styles = <String, String>{};

    if (element.localName == 'sup' || element.classes.contains('reference')) {
      return {
        'display': 'inline-block',
        'padding': '0 2px',
        'font-size': '0.75em',
        'vertical-align': 'super',
      };
    }

    /// Apply justification to common block elements
    /// Temporarily disabled
    // if (['p', 'div', 'li', 'section', 'td'].contains(element.localName)) {
    //   styles['text-align'] = 'justify';
    //   if (element.localName == 'p') {
    //     styles['margin-bottom'] = '12px';
    //   }
    // }

    if (element.localName == 'a') {
      final href = element.attributes['href'] ?? '';
      final isRedLink =
          href.contains('action=edit') || href.contains('redlink=1');
      final color = AppTheme.getLinkColor(context, isRedLink: isRedLink);
      styles['color'] = '#${color.toARGB32().toRadixString(16).substring(2)}';
      styles['text-decoration'] = 'none';
      styles['font-weight'] = '600';
    }

    return styles.isEmpty ? null : styles;
  }

  static Widget? customWidgetBuilder(
    BuildContext context,
    dom.Element element,
  ) {
    if (element.localName == 'h2') {
      final theme = Theme.of(context);
      return Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              element.text,
              style: GoogleFonts.notoSerif(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      );
    }
    return null;
  }

  static void _showReferencePopup(
    BuildContext context,
    String referenceId,
    String htmlContent,
  ) {
    final theme = Theme.of(context);
    final document = html_parser.parse(htmlContent);

    final decodedId = Uri.decodeComponent(referenceId);
    final refElement =
        document.getElementById(decodedId) ??
        document.getElementById(referenceId);

    if (refElement == null) return;

    refElement.querySelectorAll('.mw-cite-backlink').forEach((e) => e.remove());

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'reference'.tr(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            Flexible(
              child: SingleChildScrollView(
                child: HtmlWidget(
                  refElement.innerHtml,
                  textStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
