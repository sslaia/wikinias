class RecentChanges {
  final int id;
  final String title;
  final String type;
  final String user;
  final String? comment;

  RecentChanges({
    required this.id,
    required this.title,
    required this.type,
    required this.user,
    this.comment,
  });

  factory RecentChanges.fromJson(Map<String, dynamic> json) {
    return RecentChanges(
      type: json['type'] as String,
      title: json['title'] as String,
      id: json['pageid'] as int,
      user: json['user'] as String,
      comment: json['comment'] as String?,
    );
  }
}
