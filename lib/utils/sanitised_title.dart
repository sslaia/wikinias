// Removing the special characters from the title
// as they make page screen API request

String sanitisedTitle(String title) {
  String title1 = title.replaceAll("%C3%B6", "ö");
  String title2 = title1.replaceAll("%C5%B5", "ŵ");
  String title3 = title2.replaceAll("%C3%96", "Ö");
  String title4 = title3.replaceAll("%C5%B4", "Ŵ");
  String title5 = title4.replaceAll("%27", "'");
  String str = title5.replaceAll("_", " ");
  return str;
}
