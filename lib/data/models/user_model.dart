// Data layer: User data model mapping to/from backend (Firebase)
// Data Transfer Object (DTO) representing a User. Includes fromJson/toJson
// and conversion helpers to/from Domain entities.

// Placeholder: add UserModel with serialization methods.


class UserModel {
  final String id;
  final String? email;
  final String? displayName;

  UserModel({required this.id, this.email, this.displayName});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String? ?? '',
        email: json['email'] as String?,
        displayName: json['displayName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
      };
}

