class StageResource {
  final String id;
  final String stageId;
  final String title;
  final String description;
  final String url;
  final String type; // resource type string
  final bool isRequired;

  StageResource({
    required this.id,
    required this.stageId,
    required this.title,
    required this.description,
    required this.url,
    this.type = 'other',
    this.isRequired = false,
  });

  StageResource copyWith({
    String? id,
    String? stageId,
    String? title,
    String? description,
    String? url,
    String? type,
    bool? isRequired,
  }) {
    return StageResource(
      id: id ?? this.id,
      stageId: stageId ?? this.stageId,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      type: type ?? this.type,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'stageId': stageId,
        'title': title,
        'description': description,
        'url': url,
        'type': type,
        'isRequired': isRequired,
      };

  factory StageResource.fromJson(Map<String, dynamic> json) => StageResource(
        id: json['id'] as String,
        stageId: json['stageId'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        url: json['url'] as String,
        type: json['type'] as String? ?? 'other',
        isRequired: json['isRequired'] as bool? ?? false,
      );
}
