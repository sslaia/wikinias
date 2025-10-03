class Story {
  final String title;
  final String text;
  final String image;

  Story({
    required this.title,
    required this.text,
    required this.image,
  });

  // A factory constructor for creating a new FeaturedStory instance from a map.
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      title: json['title'] as String,
      text: json['text'] as String,
      image: json['image'] as String,
    );
  }
}