import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymmate_ai/src/features/home/home_screen.dart';
import 'package:gymmate_ai/src/features/home/home_dashboard_state.dart';
import 'package:gymmate_ai/src/features/home/models/home_dashboard_models.dart';
import 'package:gymmate_ai/src/features/home/repositories/home_dashboard_repository.dart';

class _FakeHomeDashboardRepository extends HomeDashboardRepository {
  @override
  Future<HomeDashboardState> fetchDashboardState() async {
    return HomeDashboardState(
      summary: DashboardSummary(currentStreak: 3, caloriesBurnedToday: 280, workoutsThisWeek: 2),
      missions: [
        DailyMission(title: 'Go to gym', detail: 'Test mission', completed: true),
      ],
      weeklyProgress: [
        WeeklyProgressItem(label: 'Mon', value: 0.7),
      ],
      history: [],
      coachMessage: AiCoachMessage(title: 'Test Coach', message: 'Keep it up.'),
    );
  }
}

void main() {
  testWidgets('HomeScreen renders dashboard content after load', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeDashboardRepositoryProvider.overrideWithValue(_FakeHomeDashboardRepository()),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('GymMate AI'), findsOneWidget);
    expect(find.text('Good morning, coach.'), findsOneWidget);
    expect(find.text('Refresh dashboard'), findsOneWidget);
    expect(find.text('Test Coach'), findsOneWidget);
  });
}
