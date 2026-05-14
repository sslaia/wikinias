import 'dart:convert';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import '../models/project_type.dart';
import '../utils/wiki_utils.dart';

class HtmlProcessor {
  static Future<Map<String, dynamic>> processArticleHtml(
    String rawHtml,
    String languageCode,
    ProjectType project,
  ) async {
    final projectStr = project.name.toLowerCase();
    final document = html_parser.parse(rawHtml);

    /// Resolve Wikipedia lazy loading
    document.querySelectorAll('noscript').forEach((ns) {
      final nsHtml = ns.innerHtml;
      if (nsHtml.contains('<img')) {
        final fragment = html_parser.parseFragment(nsHtml);
        ns.parentNode?.insertBefore(fragment, ns);
      }
      ns.remove();
    });
    document
        .querySelectorAll('.lazy-image-placeholder')
        .forEach((el) => el.remove());

    /// Handle Tables: Wrap in scrollable div (see: Wikimedia recommendation)
    document.querySelectorAll('table').forEach((table) {
      table.attributes.remove('width');
      table.attributes.remove('style');

      final wrapper = dom.Element.tag('div');
      wrapper.attributes['style'] =
          'overflow-x: auto; width: 100%; margin: 16px 0; border: 1px solid #ddd; border-radius: 8px;';
      wrapper.classes.add('table-scroll-wrapper');

      table.replaceWith(wrapper);
      wrapper.append(table);

      table.attributes['style'] = 'border-collapse: collapse; min-width: 100%;';
      table.querySelectorAll('th, td').forEach((cell) {
        cell.attributes['style'] =
            'border: 1px solid #ddd; padding: 8px; text-align: left;';
      });
    });

    /// Load rules
    final jsonString = await rootBundle.loadString(
      'assets/data/html_rules.json',
    );
    final htmlRules = jsonDecode(jsonString);
    final projectRules =
        htmlRules[languageCode]?[projectStr] as Map<String, dynamic>?;
    final globalRules =
        htmlRules['global']?[projectStr] as Map<String, dynamic>?;

    final removeSelectors = _getRulesList(globalRules, projectRules, 'remove');
    final hideSelectors = _getRulesList(globalRules, projectRules, 'hide');
    final refKeywords = _getRulesList(
      globalRules,
      projectRules,
      'referenceKeywords',
    );

    String? imageUrl;

    /// Find Hero image using centralized WikiUtils logic
    final images = document.querySelectorAll('img');
    dom.Element? heroImageElement;
    for (var img in images) {
      final src = img.attributes['src'] ?? '';
      if (!WikiUtils.isIcon(src)) {
        imageUrl = await WikiUtils.optimizeImageUrl(
          src,
          htmlString: img.outerHtml,
          width: 600,
        );
        heroImageElement = img;
        break;
      }
    }

    if (heroImageElement != null) {
      _markImageContainerForHiding(heroImageElement);
    }

    /// Process all other images using centralized WikiUtils logic
    final allImgs = document.querySelectorAll('img');
    for (var img in allImgs) {
      var src = img.attributes['src'] ?? '';
      if (src.isNotEmpty) {
        // Detect if it's an inline icon by size
        final widthAttr = int.tryParse(img.attributes['width'] ?? '');
        final heightAttr = int.tryParse(img.attributes['height'] ?? '');

        if ((widthAttr != null && widthAttr <= 48) ||
            (heightAttr != null && heightAttr <= 48)) {
          img.classes.add('wiki-inline-icon');
          // For inline icons, we don't scale up to 600px
          img.attributes['src'] = await WikiUtils.optimizeImageUrl(
            src,
            htmlString: img.outerHtml,
            width: 100,
          );
        } else {
          img.attributes['src'] = await WikiUtils.optimizeImageUrl(
            src,
            htmlString: img.outerHtml,
            width: 600,
          );
        }
      }
    }

    /// Apply removals/hides
    for (var s in removeSelectors) {
      document.querySelectorAll(s).forEach((el) => el.remove());
    }
    for (var s in hideSelectors) {
      document
          .querySelectorAll(s)
          .forEach((el) => el.attributes['style'] = 'display: none;');
    }

    /// Process reference sections
    if (refKeywords.isNotEmpty) {
      final headings = document.querySelectorAll('h2, h3, h4');
      for (var h in headings) {
        final text = h.text.toLowerCase();
        if (refKeywords.any((kw) => text.contains(kw.toLowerCase()))) {
          h.attributes['style'] = 'display: none;';
          var next = h.nextElementSibling;
          while (next != null && !['h2', 'h3', 'h4'].contains(next.localName)) {
            next.attributes['style'] = 'display: none;';
            next = next.nextElementSibling;
          }
        }
      }
    }

    /// Final cleanup and Nias Wiktionary specific processing
    String processedHtml = document.body?.innerHtml ?? '';

    if (languageCode == 'nia' && project == ProjectType.wiktionary) {
      final soup = BeautifulSoup(processedHtml);
      _removeEmptySections(soup);
      _removeEmptyImageSections(soup);
      processedHtml = soup.toString();
    }

    return {'html': processedHtml, 'imageUrl': imageUrl};
  }

  static List<String> _getRulesList(
    Map<String, dynamic>? global,
    Map<String, dynamic>? project,
    String key,
  ) {
    final list = <String>[];
    if (global != null && global[key] != null) {
      list.addAll((global[key] as List).map((e) => e.toString()));
    }
    if (project != null && project[key] != null) {
      list.addAll((project[key] as List).map((e) => e.toString()));
    }
    return list;
  }

  static void _markImageContainerForHiding(dom.Element img) {
    dom.Element? containerToHide = img;
    var parent = img.parent;
    while (parent != null && parent.localName != 'body') {
      if (parent.localName == 'figure' ||
          parent.classes.contains('thumb') ||
          parent.classes.contains('infobox-image')) {
        containerToHide = parent;
        break;
      }
      parent = parent.parent;
    }
    containerToHide?.attributes['class'] =
        '${containerToHide.attributes['class'] ?? ''} hidden-hero-container';
  }

  /// Nias Wiktionary special treatment
  /// Helper function to find and remove headings followed by "Lö hadöi"
  /// in either <dd> or <li> tags.
  static void _removeEmptySections(BeautifulSoup root) {
    /// Find all 'dd' and 'li' elements.
    final potentialMarkers = root.findAll('dd') + root.findAll('li');

    /// Use Dart's .where() to filter them based on their content
    final emptyMarkers = potentialMarkers.where((element) {
      return element.string.trim() == 'Lö hadöi';
    });

    for (final marker in emptyMarkers) {
      Bs4Element? listContainer;

      /// Determine the parent list container
      if (marker.name == 'dd') {
        listContainer = marker.findParent('dl');
      } else if (marker.name == 'li') {
        // It could be in a <ul> or <ol>
        listContainer = marker.findParent('ul') ?? marker.findParent('ol');
      }

      if (listContainer == null) continue;

      /// Find the heading element that comes just before the list container
      final headingDiv = listContainer.findPreviousSibling('div');

      /// To be safe, check if the found sibling is actually a heading container.
      if (headingDiv != null && headingDiv.className.contains('mw-heading')) {
        /// Remove the heading and the list container.
        headingDiv.extract();
        listContainer.extract();
      }
    }
  }

  /// Helper function to remove the "Gambara" heading if it has no pictures.
  static void _removeEmptyImageSections(BeautifulSoup root) {
    final imageHeadings = root.findAll('h3', id: 'Gambara');

    for (final h3 in imageHeadings) {
      final headingContainer = h3.findParent('div');
      if (headingContainer == null) continue;

      final Bs4Element? nextElement = headingContainer.nextSibling;

      if (nextElement == null || nextElement.name != 'figure') {
        headingContainer.extract();
      }
    }
  }
}
