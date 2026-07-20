class UserProfile {
  final String uid;
  final String email;
  final String fullName;
  final DateTime? dateOfBirth;
  final String gender;
  final double height;
  final double weight;
  final double goalWeight;
  final String preferredUnits;
  final String activityLevel;
  final String fitnessGoal;
  final DateTime createdAt;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.height,
    required this.weight,
    required this.goalWeight,
    required this.preferredUnits,
    required this.activityLevel,
    required this.fitnessGoal,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'height': height,
      'weight': weight,
      'goalWeight': goalWeight,
      'preferredUnits': preferredUnits,
      'activityLevel': activityLevel,
      'fitnessGoal': fitnessGoal,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.parse(map['dateOfBirth'] as String) : null,
      gender: map['gender'] as String? ?? 'Prefer not to say',
      height: (map['height'] as num).toDouble(),
      weight: (map['weight'] as num).toDouble(),
      goalWeight: (map['goalWeight'] as num).toDouble(),
      preferredUnits: map['preferredUnits'] as String? ?? 'Metric',
      activityLevel: map['activityLevel'] as String? ?? 'Moderate',
      fitnessGoal: map['fitnessGoal'] as String? ?? 'Maintain weight',
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
