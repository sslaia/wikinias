import 'package:html/parser.dart' as htm_parser;

String sanitiseHtml (String htmlString) {
  final document = htm_parser.parse(htmlString);
  final body = document.body;

  if (body == null) return htmlString;

  // Remove the infobox and navbox table
  final elementsToHide = document.querySelectorAll('.infobox, .navbox');

  // Remove each matched element from the DOM
  for (final element in elementsToHide) {
    element.remove();
  }

  // Pass new width and height for images
  // for (final img in document.getElementsByTagName('img')) {
  //   // Save the `src` attribute
  //   final src = img.attributes['src'];
  //
  //   // Clear all attributes
  //   img.attributes.clear();
  //
  //   // Restore the `src` attribute
  //   if (src != null) {
  //     img.attributes['src'] = src;
  //   }

    // Set width and height for responsiveness
    // img.attributes['width'] = '100%';
    // img.attributes['height'] = 'auto';

    // Remove `srcset` if it exists (to prevent overriding width)
    // img.attributes.remove('srcset');
  // }

  // Remove heading "Fabaliŵa lala" and everything else below it
  // final headings = document.getElementsByTagName('h2')
  // for (final heading in headings)
  return document.outerHtml;
}