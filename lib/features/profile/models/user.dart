class User {
  final String username;
  final String? bio;
  final List<String>? interests;
  final String avatarKey; // identifier for chosen built-in avatar

  User({
    required this.username,
    this.bio,
    this.interests,
    this.avatarKey = 'default',
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'bio': bio,
    'interests': interests,
    'avatarKey': avatarKey,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json['username'] as String,
    bio: json['bio'] as String?,
    interests: (json['interests'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    avatarKey: json['avatarKey'] as String? ?? 'default',
  );
}
