class Article {
  final String title;
  final String text;
  final String image;

  Article({
    required this.title,
    required this.text,
    required this.image,
  });

  // A factory constructor for creating a new FeaturedArticle instance from a map.
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String,
      text: json['text'] as String,
      image: json['image'] as String,
    );
  }
}