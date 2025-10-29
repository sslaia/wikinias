class CoursesContentItem {
  final int id;
  final String title;
  final String text;
  final String url;
  final String source;
  final String category;

  CoursesContentItem({required this.id, required this.title, required this.text, required this.url, required this.source, required this.category});

  factory CoursesContentItem.fromJson(Map<String, dynamic> json) {
    return CoursesContentItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      url: json['url'] as String? ?? '',
      source: json['source'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}
