class GalleryItem {
  final int id;
  final String title;
  final String url;
  final String source;

  GalleryItem({
    required this.id,
    required this.title,
    required this.url,
    required this.source,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      source: json['source'] as String,
    );
  }
}
