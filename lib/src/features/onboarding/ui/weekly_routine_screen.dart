import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/weekly_routine_models.dart';
import '../weekly_routine_state.dart';

class WeeklyRoutineScreen extends ConsumerWidget {
  const WeeklyRoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineState = ref.watch(weeklyRoutineProvider);
    final routineNotifier = ref.read(weeklyRoutineProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Routine'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Build the week that fits your life. Your mission plan will follow this schedule.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: routineState.days.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final day = routineState.days[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(day.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: WeeklyRoutineType.values.map((option) {
                              final label = option == WeeklyRoutineType.workGym
                                  ? 'Work + Gym'
                                  : option == WeeklyRoutineType.workOnly
                                      ? 'Work only'
                                      : 'Rest';
                              final selected = day.selection == option;
                              return ChoiceChip(
                                label: Text(label),
                                selected: selected,
                                onSelected: (_) => routineNotifier.updateDaySelection(index, option),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            PrimaryButton(
              label: 'Finish Setup',
              onPressed: () => context.go('/home'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Skip and finish'),
            ),
          ],
        ),
      ),
    );
  }
}
