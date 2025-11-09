class LearningResource {
  final String id;
  final String title;
  final String url;
  final String type;
  final String? description;
  final int? durationMinutes;
  final bool isPaid;
  final String? thumbnailUrl;

  LearningResource({
    required this.id,
    required this.title,
    required this.url,
    this.type = 'other',
    this.description,
    this.durationMinutes,
    this.isPaid = false,
    this.thumbnailUrl,
  });

  LearningResource copyWith({
    String? id,
    String? title,
    String? url,
    String? type,
    String? description,
    int? durationMinutes,
    bool? isPaid,
    String? thumbnailUrl,
  }) {
    return LearningResource(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      type: type ?? this.type,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isPaid: isPaid ?? this.isPaid,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'type': type,
        'description': description,
        'durationMinutes': durationMinutes,
        'isPaid': isPaid,
        'thumbnailUrl': thumbnailUrl,
      };

  factory LearningResource.fromJson(Map<String, dynamic> json) => LearningResource(
        id: json['id'] as String,
        title: json['title'] as String,
        url: json['url'] as String,
        type: json['type'] as String? ?? 'other',
        description: json['description'] as String?,
        durationMinutes: json['durationMinutes'] as int?,
        isPaid: json['isPaid'] as bool? ?? false,
        thumbnailUrl: json['thumbnailUrl'] as String?,
      );
}
