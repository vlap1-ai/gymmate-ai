class UserProfile {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? gymName;
  final DateTime createdAt;

  const UserProfile({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.gymName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gymName': gymName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      gymName: map['gymName'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
