import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wikimedia_core/wikimedia_core.dart';

import '../providers/history_provider.dart';
import '../screens/article_screen.dart';
import '../screens/create_page_screen.dart';
import '../screens/create_entry_screen.dart';
import '../screens/create_book_screen.dart';
import '../theme/app_theme.dart';

class WikiUtils {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<String> optimizeImageUrl(
    String url, {
    String? htmlString,
    int width = 500,
  }) async {
    return CoreWikiUtils.optimizeImageUrl(
      url,
      htmlString: htmlString,
      width: width,
    );
  }

  static Future<bool> handleTapUrl(
    BuildContext context,
    String url,
    String? htmlContent,
    ProjectType currentProject,
    String languageCode,
  ) async {
    final intent = await CoreWikiUtils.handleTapUrl(
      url,
      languageCode,
      currentProject,
    );

    if (intent is IgnoreLinkIntent) return false;
    if (!context.mounted) return false;

    if (intent is ShowReferenceIntent) {
      if (htmlContent != null) {
        _showReferencePopup(context, intent.referenceId, htmlContent);
      }
      return true;
    }

    if (intent is OpenExternalUrlIntent) {
      _launchExternalUrl(intent.url);
      return true;
    }

    if (intent is PlayAudioIntent) {
      await _playAudio(context, intent.audioUrl);
      return true;
    }

    if (intent is NavigateToArticleIntent) {
      final container = ProviderScope.containerOf(context);
      container.read(historyProvider.notifier).push(intent.title);

      if (intent.isRedLink) {
        Widget screen;
        switch (currentProject) {
          case ProjectType.wiktionary:
            screen = CreateEntryScreen(title: intent.title);
            break;
          case ProjectType.wikibooks:
            screen = CreateBookScreen(title: intent.title);
            break;
          case ProjectType.wikipedia:
            screen = CreatePageScreen(initialTitle: intent.title);
            break;
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ArticleScreen(title: intent.title)),
        );
      }
      return true;
    }

    return false;
  }

  static Future<void> _launchExternalUrl(String urlString) async {
    final url = Uri.parse(
      urlString.startsWith('//') ? 'https:$urlString' : urlString,
    );
    if (await canLaunchUrl(url))
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
  }

  static Future<void> _playAudio(BuildContext context, String audioUrl) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Text('playing_audio'.tr()),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      await _audioPlayer.stop();
      try {
        await _audioPlayer.setUrl(audioUrl, headers: WikiConfig.uaHeaders);
      } catch (e) {
        await _audioPlayer.setUrl(audioUrl);
      }
      await _audioPlayer.play();
    } catch (e) {
      if (context.mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('play_audio_error'.tr())));
    }
  }

  static bool _isHidden(dom.Element element) {
    dom.Element? current = element;
    while (current != null) {
      if (current.classes.contains('wikinias-hidden')) return true;
      current = current.parent;
    }
    return false;
  }

  static Map<String, String>? customStyles(
    BuildContext context,
    dom.Element element,
  ) {
    if (_isHidden(element)) return {'display': 'none'};
    final styles = <String, String>{};
    if (element.localName == 'sup' || element.classes.contains('reference'))
      return {
        'display': 'inline-block',
        'padding': '0 2px',
        'font-size': '0.75em',
        'vertical-align': 'super',
      };
    if (element.localName == 'a') {
      final href = element.attributes['href'] ?? '';
      final color = AppTheme.getLinkColor(
        context,
        isRedLink: href.contains('action=edit') || href.contains('redlink=1'),
      );
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
    // Check if current element or any parent is marked as hidden
    if (_isHidden(element)) return const SizedBox.shrink();

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

    // Robust search: getElementById or suffix match (for Wikibooks/Incubator IDs)
    dom.Element? refElement =
        document.getElementById(decodedId) ??
        document.getElementById(referenceId);

    if (refElement == null) {
      final allWithId = document.querySelectorAll('[id]');
      for (var el in allWithId) {
        final id = el.attributes['id'] ?? '';
        if (id.endsWith(decodedId) || id.endsWith(referenceId)) {
          refElement = el;
          break;
        }
      }
    }

    if (refElement == null) return;

    final refClone = refElement.clone(true);
    refClone.querySelectorAll('.mw-cite-backlink').forEach((e) => e.remove());

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
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                  refClone.innerHtml,
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
