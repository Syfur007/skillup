// filepath: /home/syfur/Android/Flutter/skillup/lib/domain/models/user.dart

enum AuthProvider {
  email,
  google,
  github;

  String toJson() => name;
  static AuthProvider fromJson(String value) {
    return AuthProvider.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AuthProvider.email,
    );
  }
}

class UserPreferences {
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool groupUpdatesEnabled;
  final bool roadmapRemindersEnabled;
  final bool achievementNotificationsEnabled;
  final String theme; // 'light', 'dark', 'system'
  final String language;

  UserPreferences({
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.groupUpdatesEnabled = true,
    this.roadmapRemindersEnabled = true,
    this.achievementNotificationsEnabled = true,
    this.theme = 'system',
    this.language = 'en',
  });

  Map<String, dynamic> toJson() => {
        'pushNotificationsEnabled': pushNotificationsEnabled,
        'emailNotificationsEnabled': emailNotificationsEnabled,
        'groupUpdatesEnabled': groupUpdatesEnabled,
        'roadmapRemindersEnabled': roadmapRemindersEnabled,
        'achievementNotificationsEnabled': achievementNotificationsEnabled,
        'theme': theme,
        'language': language,
      };

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      UserPreferences(
        pushNotificationsEnabled:
            json['pushNotificationsEnabled'] as bool? ?? true,
        emailNotificationsEnabled:
            json['emailNotificationsEnabled'] as bool? ?? true,
        groupUpdatesEnabled: json['groupUpdatesEnabled'] as bool? ?? true,
        roadmapRemindersEnabled: json['roadmapRemindersEnabled'] as bool? ?? true,
        achievementNotificationsEnabled:
            json['achievementNotificationsEnabled'] as bool? ?? true,
        theme: json['theme'] as String? ?? 'system',
        language: json['language'] as String? ?? 'en',
      );

  UserPreferences copyWith({
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? groupUpdatesEnabled,
    bool? roadmapRemindersEnabled,
    bool? achievementNotificationsEnabled,
    String? theme,
    String? language,
  }) {
    return UserPreferences(
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      groupUpdatesEnabled: groupUpdatesEnabled ?? this.groupUpdatesEnabled,
      roadmapRemindersEnabled:
          roadmapRemindersEnabled ?? this.roadmapRemindersEnabled,
      achievementNotificationsEnabled: achievementNotificationsEnabled ??
          this.achievementNotificationsEnabled,
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }
}

class UserPrivacySettings {
  final bool emailVisible;
  final bool interestsVisible;
  final bool bioVisible;
  final bool progressVisible;

  UserPrivacySettings({
    this.emailVisible = false,
    this.interestsVisible = true,
    this.bioVisible = true,
    this.progressVisible = true,
  });

  Map<String, dynamic> toJson() => {
        'emailVisible': emailVisible,
        'interestsVisible': interestsVisible,
        'bioVisible': bioVisible,
        'progressVisible': progressVisible,
      };

  factory UserPrivacySettings.fromJson(Map<String, dynamic> json) =>
      UserPrivacySettings(
        emailVisible: json['emailVisible'] as bool? ?? false,
        interestsVisible: json['interestsVisible'] as bool? ?? true,
        bioVisible: json['bioVisible'] as bool? ?? true,
        progressVisible: json['progressVisible'] as bool? ?? true,
      );

  UserPrivacySettings copyWith({
    bool? emailVisible,
    bool? interestsVisible,
    bool? bioVisible,
    bool? progressVisible,
  }) {
    return UserPrivacySettings(
      emailVisible: emailVisible ?? this.emailVisible,
      interestsVisible: interestsVisible ?? this.interestsVisible,
      bioVisible: bioVisible ?? this.bioVisible,
      progressVisible: progressVisible ?? this.progressVisible,
    );
  }
}

class User {
  final String id;
  final String email;
  final String username;
  final String? displayName;
  final String? bio;
  final String? profilePictureUrl;
  final List<String> interests;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool onboardingCompleted;
  final AuthProvider authProvider;
  final UserPreferences preferences;
  final UserPrivacySettings privacySettings;
  final List<String> activeRoadmapIds;
  final List<String> completedRoadmapIds;
  final List<String> groupIds;
  final int totalPoints;
  final String avatarKey; // identifier for chosen built-in avatar

  User({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.bio,
    this.profilePictureUrl,
    List<String>? interests,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.onboardingCompleted = false,
    this.authProvider = AuthProvider.email,
    UserPreferences? preferences,
    UserPrivacySettings? privacySettings,
    List<String>? activeRoadmapIds,
    List<String>? completedRoadmapIds,
    List<String>? groupIds,
    this.totalPoints = 0,
    this.avatarKey = 'default',
  })  : interests = interests ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        preferences = preferences ?? UserPreferences(),
        privacySettings = privacySettings ?? UserPrivacySettings(),
        activeRoadmapIds = activeRoadmapIds ?? [],
        completedRoadmapIds = completedRoadmapIds ?? [],
        groupIds = groupIds ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'displayName': displayName,
        'bio': bio,
        'profilePictureUrl': profilePictureUrl,
        'interests': interests,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'onboardingCompleted': onboardingCompleted,
        'authProvider': authProvider.toJson(),
        'preferences': preferences.toJson(),
        'privacySettings': privacySettings.toJson(),
        'activeRoadmapIds': activeRoadmapIds,
        'completedRoadmapIds': completedRoadmapIds,
        'groupIds': groupIds,
        'totalPoints': totalPoints,
        'avatarKey': avatarKey,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        username: json['username'] as String,
        displayName: json['displayName'] as String?,
        bio: json['bio'] as String?,
        profilePictureUrl: json['profilePictureUrl'] as String?,
        interests: (json['interests'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : DateTime.now(),
        onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
        authProvider: json['authProvider'] != null
            ? AuthProvider.fromJson(json['authProvider'] as String)
            : AuthProvider.email,
        preferences: json['preferences'] != null
            ? UserPreferences.fromJson(
                json['preferences'] as Map<String, dynamic>)
            : UserPreferences(),
        privacySettings: json['privacySettings'] != null
            ? UserPrivacySettings.fromJson(
                json['privacySettings'] as Map<String, dynamic>)
            : UserPrivacySettings(),
        activeRoadmapIds: (json['activeRoadmapIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        completedRoadmapIds: (json['completedRoadmapIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        groupIds: (json['groupIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        totalPoints: json['totalPoints'] as int? ?? 0,
        avatarKey: json['avatarKey'] as String? ?? 'default',
      );

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? bio,
    String? profilePictureUrl,
    List<String>? interests,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? onboardingCompleted,
    AuthProvider? authProvider,
    UserPreferences? preferences,
    UserPrivacySettings? privacySettings,
    List<String>? activeRoadmapIds,
    List<String>? completedRoadmapIds,
    List<String>? groupIds,
    int? totalPoints,
    String? avatarKey,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      interests: interests ?? this.interests,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      authProvider: authProvider ?? this.authProvider,
      preferences: preferences ?? this.preferences,
      privacySettings: privacySettings ?? this.privacySettings,
      activeRoadmapIds: activeRoadmapIds ?? this.activeRoadmapIds,
      completedRoadmapIds: completedRoadmapIds ?? this.completedRoadmapIds,
      groupIds: groupIds ?? this.groupIds,
      totalPoints: totalPoints ?? this.totalPoints,
      avatarKey: avatarKey ?? this.avatarKey,
    );
  }
}

