enum WeeklyRoutineType {
  workGym,
  workOnly,
  rest,
}

class WeeklyRoutineDay {
  final String name;
  final WeeklyRoutineType selection;

  const WeeklyRoutineDay({
    required this.name,
    required this.selection,
  });

  WeeklyRoutineDay copyWith({WeeklyRoutineType? selection}) {
    return WeeklyRoutineDay(
      name: name,
      selection: selection ?? this.selection,
    );
  }
}

class WeeklyRoutineState {
  final List<WeeklyRoutineDay> days;

  const WeeklyRoutineState(this.days);

  WeeklyRoutineState copyWith({List<WeeklyRoutineDay>? days}) {
    return WeeklyRoutineState(days ?? this.days);
  }

  static WeeklyRoutineState initial() {
    return WeeklyRoutineState([
      const WeeklyRoutineDay(name: 'Monday', selection: WeeklyRoutineType.workGym),
      const WeeklyRoutineDay(name: 'Tuesday', selection: WeeklyRoutineType.workGym),
      const WeeklyRoutineDay(name: 'Wednesday', selection: WeeklyRoutineType.workGym),
      const WeeklyRoutineDay(name: 'Thursday', selection: WeeklyRoutineType.workGym),
      const WeeklyRoutineDay(name: 'Friday', selection: WeeklyRoutineType.workGym),
      const WeeklyRoutineDay(name: 'Saturday', selection: WeeklyRoutineType.rest),
      const WeeklyRoutineDay(name: 'Sunday', selection: WeeklyRoutineType.rest),
    ]);
  }
}
