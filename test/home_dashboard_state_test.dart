import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymmate_ai/src/features/home/home_dashboard_state.dart';
import 'package:gymmate_ai/src/features/home/models/home_dashboard_models.dart';
import 'package:gymmate_ai/src/features/home/repositories/home_dashboard_repository.dart';

class _FakeHomeDashboardRepository extends HomeDashboardRepository {
  @override
  Future<HomeDashboardState> fetchDashboardState() async {
    return HomeDashboardState(
      summary: DashboardSummary(currentStreak: 10, caloriesBurnedToday: 600, workoutsThisWeek: 5),
      missions: const [],
      weeklyProgress: const [],
      history: const [],
      coachMessage: AiCoachMessage(title: 'Test', message: 'Test message'),
    );
  }
}

void main() {
  test('HomeDashboardNotifier loads expected dashboard state', () async {
    final container = ProviderContainer(
      overrides: [
        homeDashboardRepositoryProvider.overrideWithValue(_FakeHomeDashboardRepository()),
      ],
    );
    addTearDown(container.dispose);

    final loadedState = await container.read(homeDashboardProvider.future);

    expect(loadedState.summary.currentStreak, 10);
    expect(loadedState.summary.caloriesBurnedToday, 600);
    expect(loadedState.coachMessage.title, 'Test');
  });
}
