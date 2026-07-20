import '../models/home_dashboard_models.dart';

abstract class HomeDashboardRepository {
  Future<HomeDashboardState> fetchDashboardState();
}

class LocalHomeDashboardRepository implements HomeDashboardRepository {
  @override
  Future<HomeDashboardState> fetchDashboardState() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return HomeDashboardState(
      summary: DashboardSummary(
        currentStreak: 7,
        caloriesBurnedToday: 520,
        workoutsThisWeek: 4,
      ),
      missions: [
        DailyMission(
          title: 'Go to gym',
          detail: 'Enter your registered gym location',
          completed: true,
        ),
        DailyMission(
          title: 'Complete workout',
          detail: 'Finish today’s planned training session',
          completed: false,
        ),
        DailyMission(
          title: 'Drink water',
          detail: 'Stay hydrated before and after training',
          completed: false,
        ),
      ],
      weeklyProgress: [
        WeeklyProgressItem(label: 'Mon', value: 0.8),
        WeeklyProgressItem(label: 'Tue', value: 0.7),
        WeeklyProgressItem(label: 'Wed', value: 0.9),
        WeeklyProgressItem(label: 'Thu', value: 0.6),
        WeeklyProgressItem(label: 'Fri', value: 0.85),
        WeeklyProgressItem(label: 'Sat', value: 0.2),
        WeeklyProgressItem(label: 'Sun', value: 0.0),
      ],
      history: [
        WorkoutHistoryEntry(
          date: DateTime.now().subtract(const Duration(days: 1)),
          workoutType: 'Strength',
          calories: 430,
          durationMinutes: 55,
          completed: true,
        ),
        WorkoutHistoryEntry(
          date: DateTime.now().subtract(const Duration(days: 2)),
          workoutType: 'Cardio',
          calories: 360,
          durationMinutes: 42,
          completed: true,
        ),
        WorkoutHistoryEntry(
          date: DateTime.now().subtract(const Duration(days: 3)),
          workoutType: 'Rest',
          calories: 0,
          durationMinutes: 0,
          completed: false,
        ),
      ],
      coachMessage: AiCoachMessage(
        title: 'Let’s build momentum',
        message: 'You’re on a strong streak. I’ve tailored today’s workout to keep your recovery smart and your progress steady.',
      ),
    );
  }
}
