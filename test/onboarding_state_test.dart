import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymmate_ai/src/features/onboarding/models/onboarding_models.dart';
import 'package:gymmate_ai/src/features/onboarding/onboarding_state.dart';

void main() {
  test('OnboardingDataNotifier preserves field updates', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(onboardingDataProvider.notifier);
    notifier.updateNames('Alex', 'Taylor');
    notifier.updateBirthday(DateTime(1990, 7, 20));
    notifier.updateGender(Gender.other);
    notifier.updatePhysical(180, 75);
    notifier.updateFitnessGoal(FitnessGoal.gainMuscle);
    notifier.updateGymName('Titan Fitness');

    final state = container.read(onboardingDataProvider);
    expect(state.firstName, 'Alex');
    expect(state.lastName, 'Taylor');
    expect(state.birthday, DateTime(1990, 7, 20));
    expect(state.gender, Gender.other);
    expect(state.heightCm, 180);
    expect(state.weightKg, 75);
    expect(state.fitnessGoal, FitnessGoal.gainMuscle);
    expect(state.gymName, 'Titan Fitness');
  });
}
