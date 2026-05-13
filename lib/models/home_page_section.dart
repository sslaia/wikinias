class HomePageSection {
  final String titleKey;
  final String textHtml;
  final Map<String, String?> data;

  HomePageSection({
    required this.titleKey,
    required this.textHtml,
    required this.data,
  });

  /// Helper to get the image HTML using the dynamic key
  String? get imageHtml => data['${titleKey}ImageHtml'];

  /// Helper to get the image URL using the dynamic key
  String? get imageUrl => data['${titleKey}ImageUrl'];

  Map<String, dynamic> toJson() => {
        'titleKey': titleKey,
        'textHtml': textHtml,
        'data': data,
      };

  factory HomePageSection.fromJson(Map<String, dynamic> json) => HomePageSection(
        titleKey: json['titleKey'],
        textHtml: json['textHtml'],
        data: Map<String, String?>.from(json['data'] ?? {}),
      );
}
