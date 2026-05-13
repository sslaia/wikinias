class GalleryItem {
  final String title;
  final String fileName;
  final String category;
  final String? description;

  GalleryItem({
    required this.title,
    required this.fileName,
    required this.category,
    this.description,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      title: json['title'] ?? '',
      fileName: json['fileName'] ?? '',
      category: json['category'] ?? 'others',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fileName': fileName,
      'category': category,
      'description': description,
    };
  }
}
