class Word {
  final String word;
  final String definition;
  final String example;

  Word({
    required this.word,
    required this.definition,
    required this.example,
  });

  // A factory constructor for creating a new FeaturedWord instance from a map.
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] as String,
      definition: json['definition'] as String,
      example: json['example'] as String,
    );
  }
}