import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/weekly_routine_models.dart';

final weeklyRoutineProvider = NotifierProvider<WeeklyRoutineNotifier, WeeklyRoutineState>(
  WeeklyRoutineNotifier.new,
);

class WeeklyRoutineNotifier extends Notifier<WeeklyRoutineState> {
  @override
  WeeklyRoutineState build() => WeeklyRoutineState.initial();

  void updateDaySelection(int index, WeeklyRoutineType type) {
    final updatedDays = state.days.toList();
    updatedDays[index] = updatedDays[index].copyWith(selection: type);
    state = state.copyWith(days: List.unmodifiable(updatedDays));
  }
}
