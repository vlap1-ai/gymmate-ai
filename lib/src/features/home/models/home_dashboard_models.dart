class DailyMission {
  final String title;
  final String detail;
  final bool completed;

  DailyMission({
    required this.title,
    required this.detail,
    this.completed = false,
  });
}

class DashboardSummary {
  final int currentStreak;
  final int caloriesBurnedToday;
  final int workoutsThisWeek;

  DashboardSummary({
    required this.currentStreak,
    required this.caloriesBurnedToday,
    required this.workoutsThisWeek,
  });
}

class WeeklyProgressItem {
  final String label;
  final double value;

  WeeklyProgressItem({
    required this.label,
    required this.value,
  });
}

class WorkoutHistoryEntry {
  final DateTime date;
  final String workoutType;
  final int calories;
  final int durationMinutes;
  final bool completed;

  WorkoutHistoryEntry({
    required this.date,
    required this.workoutType,
    required this.calories,
    required this.durationMinutes,
    required this.completed,
  });
}

class AiCoachMessage {
  final String title;
  final String message;

  AiCoachMessage({
    required this.title,
    required this.message,
  });
}

class HomeDashboardState {
  final DashboardSummary summary;
  final List<DailyMission> missions;
  final List<WeeklyProgressItem> weeklyProgress;
  final List<WorkoutHistoryEntry> history;
  final AiCoachMessage coachMessage;

  HomeDashboardState({
    required this.summary,
    required this.missions,
    required this.weeklyProgress,
    required this.history,
    required this.coachMessage,
  });
}
