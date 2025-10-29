class GalleryContentItem {
  final int id;
  final String title;
  final String url;
  final String source;
  final String category;

  GalleryContentItem({required this.id, required this.title, required this.url, required this.source, required this.category});

  factory GalleryContentItem.fromJson(Map<String, dynamic> json) {
    return GalleryContentItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      source: json['source'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}
