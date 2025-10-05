import 'sanitised_title.dart';

String getCapitalisedTitleFromUrl (String url) {
  // This is only valid for Wikipedia and Wikikamus
  const start = "title=";
  const end = "action";
  final startIndex = url.indexOf(start);
  final endIndex = url.indexOf(end);
  final newTitle = url.substring(startIndex + start.length, endIndex - 1);
  final sanitisedNewTitle = sanitisedTitle(newTitle);

  // the following is deactivated as it creates issues with Namespace:XYZ
  // for example Wiktionary:Angombakhata becomes Wiktionary:angomakhata
  // final newPageTitle = (sanitisedNewTitle).toLowerCase();

  final capitalisedTitle = sanitisedNewTitle.split(" ").map((word) => word.capitalize()).join(" ");
  return capitalisedTitle;

}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
