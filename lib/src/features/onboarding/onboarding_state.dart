import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/onboarding_models.dart';

final onboardingDataProvider = NotifierProvider<OnboardingDataNotifier, OnboardingData>(
  OnboardingDataNotifier.new,
);

class OnboardingDataNotifier extends Notifier<OnboardingData> {
  @override
  OnboardingData build() => const OnboardingData();

  void updateNames(String firstName, String lastName) {
    state = state.copyWith(firstName: firstName.trim(), lastName: lastName.trim());
  }

  void updateBirthday(DateTime birthday) {
    state = state.copyWith(birthday: birthday);
  }

  void updateGender(Gender gender) {
    state = state.copyWith(gender: gender);
  }

  void updatePhysical(double heightCm, double weightKg) {
    state = state.copyWith(heightCm: heightCm, weightKg: weightKg);
  }

  void updateFitnessGoal(FitnessGoal fitnessGoal) {
    state = state.copyWith(fitnessGoal: fitnessGoal);
  }

  void updateGymName(String gymName) {
    state = state.copyWith(gymName: gymName.trim());
  }
}
