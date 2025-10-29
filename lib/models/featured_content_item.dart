class FeaturedContentItem {
  final int id;
  final String title;
  final String text;
  final String image;

  FeaturedContentItem({required this.id, required this.title, required this.text, required this.image});

  factory FeaturedContentItem.fromJson(Map<String, dynamic> json) {
    return FeaturedContentItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

// For possible future expansion with similar structure to FeaturedContentItem
// and reuse FeaturedContentItem as a generic "ContentItem".
class ContentItem extends FeaturedContentItem {
  ContentItem({required super.id, required super.title, required super.text, required super.image});

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}
