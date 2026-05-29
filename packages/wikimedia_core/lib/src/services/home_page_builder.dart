import 'dart:convert';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import '../models/home_page_section.dart';
import '../models/project_type.dart';
import '../utils/wiki_utils.dart'; // TODO: migrate CoreWikiUtils
import '../core/wiki_config.dart';

class HomePageBuilder {
  static Future<List<HomePageSection>> build(
    List<int> responseBodyBytes,
    String languageCode,
    ProjectType project,
  ) async {
    final projectStr = project.name.toLowerCase();

    /// Decode with UTF-8 to handle foreign characters properly
    final bodyStr = utf8.decode(responseBodyBytes);
    final document = html_parser.parse(bodyStr);

    final removeSelectors = WikiConfig.getCombinedRulesList(languageCode, projectStr, 'remove');
    final hideSelectors = WikiConfig.getCombinedRulesList(languageCode, projectStr, 'hide');

    final projectRules = WikiConfig.getRules(languageCode, projectStr);
    final sectionsConfig = projectRules?['homePageSections'] as Map<String, dynamic>?;

    List<HomePageSection> sections = [];

    if (sectionsConfig != null) {
      for (final entry in sectionsConfig.entries) {
        final titleKey = entry.key;
        final dynamic config = entry.value;

        String selector;
        dynamic keepSelector;
        bool firstOnly = false;
        bool stripStyle = true;

        if (config is Map) {
          selector = config['selector'] ?? '';
          keepSelector = config['keep'];
          firstOnly = config['firstOnly'] ?? false;
        } else {
          selector = config.toString();
        }

        if (selector.isEmpty) continue;

        final finalSelector =
            selector.startsWith('.') || selector.startsWith('#')
            ? selector
            : '#$selector';

        final element = document.querySelector(finalSelector);

        if (element != null) {
          sections.add(
            await _extractSection(
              element,
              titleKey,
              languageCode: languageCode,
              projectStr: projectStr,
              removeSelectors: removeSelectors,
              hideSelectors: hideSelectors,
              keepSelector: keepSelector,
              firstOnly: firstOnly,
              stripStyle: stripStyle,
            ),
          );
        }
      }
    }

    /// Enhanced Fallback Logic for Wiktionary and pages with different structures
    if (sections.isEmpty) {
      final containers = [
        '#mw-content-text',
        '.mw-parser-output',
        '#bodyContent',
        '.mf-index',
      ];

      dom.Element? mainContent;
      for (var selector in containers) {
        mainContent = document.querySelector(selector);
        if (mainContent != null) break;
      }

      if (mainContent != null) {
        final fallbackSections = mainContent.querySelectorAll(
          'section, .mf-section-0',
        );
        if (fallbackSections.isNotEmpty) {
          for (var section in fallbackSections) {
            if (section.text.trim().length > 50) {
              sections.add(
                await _extractSection(
                  section,
                  'mainContent',
                  languageCode: languageCode,
                  projectStr: projectStr,
                  stripStyle: true,
                ),
              );
            }
          }
        } else {
          sections.add(
            await _extractSection(
              mainContent,
              'mainContent',
              languageCode: languageCode,
              projectStr: projectStr,
              stripStyle: true,
            ),
          );
        }
      }
    }

    if (sections.isEmpty) {
      sections.add(
        HomePageSection(
          titleKey: 'no_content',
          textHtml:
              '<i>No specific content found for this language and project.</i>',
          data: {},
        ),
      );
    }

    return sections;
  }

  static Future<HomePageSection> _extractSection(
    dom.Element element,
    String titleKey, {
    required String languageCode,
    required String projectStr,
    List<String> removeSelectors = const [],
    List<String> hideSelectors = const [],
    dynamic keepSelector,
    bool firstOnly = false,
    bool stripStyle = false,
  }) async {
    /// Find the first valid image that is NOT an icon
    final allImages = element.querySelectorAll('img');
    dom.Element? validImg;

    for (var img in allImages) {
      final src = img.attributes['src'] ?? '';
      if (!CoreWikiUtils.isIcon(src)) {
        validImg = img;
        break;
      }
    }

    String? imageHtml;
    String? imageUrl;

    if (validImg != null) {
      final imgClone = validImg.clone(true);
      String? src = imgClone.attributes['src'];
      if (src != null) {
        imageUrl = await CoreWikiUtils.optimizeImageUrl(
          src,
          htmlString: validImg.outerHtml,
          width: 500, // Updated to 500
        );
        imgClone.attributes['src'] = imageUrl;
      }

      imgClone.attributes.remove('srcset');
      imgClone.attributes.remove('width');
      imgClone.attributes.remove('height');
      imgClone.attributes['style'] =
          'width: 100%; height: auto; display: block; border-radius: 12px;';

      imageHtml = imgClone.outerHtml;
      validImg.remove();
    }

    /// Apply removals
    for (var s in removeSelectors) {
      if (s == 'img' || s == 'figure') continue;
      element.querySelectorAll(s).forEach((el) => el.remove());
    }
    for (var s in hideSelectors) {
      if (s == 'img' || s == 'figure') continue;
      element.querySelectorAll(s).forEach((el) => el.remove());
    }

    /// Filter content
    String textHtml;
    if (keepSelector != null) {
      final List<String> selectors = keepSelector is List
          ? List<String>.from(keepSelector)
          : [keepSelector.toString()];

      List<String> htmlParts = [];
      for (var s in selectors) {
        if (firstOnly) {
          final allKept = element.querySelectorAll(s);
          dom.Element? kept;
          for (var el in allKept) {
            if (el.text.trim().isNotEmpty) {
              kept = el;
              break;
            }
          }
          if (kept != null) {
            if (stripStyle) {
              kept.attributes.remove('style');
              kept
                  .querySelectorAll('*')
                  .forEach((child) => child.attributes.remove('style'));
            }
            htmlParts.add(kept.outerHtml);
          }
        } else {
          final kept = element.querySelectorAll(s);
          if (stripStyle) {
            for (var el in kept) {
              el.attributes.remove('style');
              el
                  .querySelectorAll('*')
                  .forEach((child) => child.attributes.remove('style'));
            }
          }
          htmlParts.addAll(kept.map((e) => e.outerHtml));
        }
      }
      textHtml = htmlParts.join();
    } else {
      if (stripStyle) {
        element.attributes.remove('style');
        element
            .querySelectorAll('*')
            .forEach((child) => child.attributes.remove('style'));
      }
      textHtml = element.innerHtml;
    }

    final Map<String, String?> sectionData = {
      '${titleKey}ImageHtml': imageHtml,
      '${titleKey}ImageUrl': imageUrl,
    };

    return HomePageSection(
      titleKey: titleKey,
      textHtml: textHtml,
      data: sectionData,
    );
  }
}
