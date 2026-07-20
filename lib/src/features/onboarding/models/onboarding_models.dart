enum Gender { male, female, other }

enum FitnessGoal { gainMuscle, loseFat, maintain }

class OnboardingData {
  final String firstName;
  final String lastName;
  final DateTime? birthday;
  final Gender? gender;
  final double? heightCm;
  final double? weightKg;
  final FitnessGoal? fitnessGoal;
  final String gymName;

  const OnboardingData({
    this.firstName = '',
    this.lastName = '',
    this.birthday,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.fitnessGoal,
    this.gymName = '',
  });

  OnboardingData copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthday,
    Gender? gender,
    double? heightCm,
    double? weightKg,
    FitnessGoal? fitnessGoal,
    String? gymName,
  }) {
    return OnboardingData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      gymName: gymName ?? this.gymName,
    );
  }
}
