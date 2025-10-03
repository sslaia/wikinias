class Dyk {
  final String title;
  final String text;
  final String image;

  Dyk({
    required this.title,
    required this.text,
    required this.image,
  });

  factory Dyk.fromJson(Map<String, dynamic> json) {
    return Dyk(
      title: json['title'] as String,
      text: json['text'] as String,
      image: json['image'] as String,
    );
  }
}