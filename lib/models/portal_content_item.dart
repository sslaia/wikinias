class PortalContentItem {
  final int id;
  final String title;
  final String text;
  final String image;
  final String portal;
  final String wiki;

  PortalContentItem({required this.id, required this.title, required this.text, required this.image, required this.portal, required this.wiki});

  factory PortalContentItem.fromJson(Map<String, dynamic> json) {
    return PortalContentItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      image: json['image'] as String? ?? '',
      portal: json['portal'] as String? ?? '',
      wiki: json['wiki'] as String? ?? '',
    );
  }
}
