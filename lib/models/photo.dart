class Photo {
  final String title;
  final String url;
  final String source;

  Photo({
    required this.title,
    required this.url,
    required this.source,
  });

  // A factory constructor for creating a new FeaturedStory instance from a map.
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      title: json['title'] as String,
      url: json['url'] as String,
      source: json['source'] as String,
    );
  }
}