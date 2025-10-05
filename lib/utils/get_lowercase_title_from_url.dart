import 'sanitised_title.dart';

String getLowercaseTitleFromUrl (String url) {
  const start = "title=";
  const end = "action";
  final startIndex = url.indexOf(start);
  final endIndex = url.indexOf(end);
  final newTitle = url.substring(startIndex + start.length, endIndex - 1);
  final sanitisedNewTitle = sanitisedTitle(newTitle);
  // Make sure the Namespace page title is not lowercased and leave it untouched
  if (sanitisedNewTitle.contains(':')) {
    return sanitisedNewTitle;
  } else {
    final lowercaseTitle = (sanitisedNewTitle).toLowerCase();
    return lowercaseTitle;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
