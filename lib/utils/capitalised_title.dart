// capitalize the first letter of each word in a string
// used for new Wikipedia and Wikibuku articles
String getCapitalizedTitle(String title) {
  final newTitle = title.split(" ").map((word) => word.capitalize()).join(" ");
  return newTitle;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
