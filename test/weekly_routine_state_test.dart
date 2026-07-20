import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymmate_ai/src/features/onboarding/models/weekly_routine_models.dart';
import 'package:gymmate_ai/src/features/onboarding/weekly_routine_state.dart';

void main() {
  test('WeeklyRoutineNotifier updates day selection immutably', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(weeklyRoutineProvider.notifier);
    final initialState = container.read(weeklyRoutineProvider);
    expect(initialState.days[0].selection, WeeklyRoutineType.workGym);

    notifier.updateDaySelection(0, WeeklyRoutineType.rest);
    final updatedState = container.read(weeklyRoutineProvider);

    expect(updatedState.days[0].selection, WeeklyRoutineType.rest);
    expect(initialState.days[0].selection, WeeklyRoutineType.workGym);
  });
}
