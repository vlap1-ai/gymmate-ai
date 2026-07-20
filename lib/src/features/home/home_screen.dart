import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/primary_button.dart';
import 'home_dashboard_state.dart';
import 'models/home_dashboard_models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(homeDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GymMate AI'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
            tooltip: 'Settings',
          ),
        ],
      ),
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Unable to load dashboard: $error'),
        ),
        data: (dashboard) => _HomeDashboardView(dashboard: dashboard),
      ),
    );
  }
}

class _HomeDashboardView extends StatelessWidget {
  final HomeDashboardState dashboard;

  const _HomeDashboardView({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Good morning, coach.', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Today’s mission is ready. Your AI companion is tracking what matters automatically.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          _MissionSummaryCard(missions: dashboard.missions),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _SummaryCard(label: 'Current streak', value: '${dashboard.summary.currentStreak} days')),
              const SizedBox(width: 12),
              Expanded(child: _SummaryCard(label: 'Calories burned', value: '${dashboard.summary.caloriesBurnedToday} kcal')),
            ],
          ),
          const SizedBox(height: 12),
          _SummaryCard(label: 'Workouts this week', value: '${dashboard.summary.workoutsThisWeek}', icon: Icons.bar_chart),
          const SizedBox(height: 20),
          _AiCoachCard(message: dashboard.coachMessage),
          const SizedBox(height: 20),
          _WeeklyProgressCard(items: dashboard.weeklyProgress),
          const SizedBox(height: 20),
          _WorkoutHistoryCard(history: dashboard.history),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, child) {
              return PrimaryButton(
                label: 'Refresh dashboard',
                onPressed: () => ref.read(homeDashboardProvider.notifier).refresh(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MissionSummaryCard extends StatelessWidget {
  final List<DailyMission> missions;

  const _MissionSummaryCard({required this.missions});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today’s Mission', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...missions.map((mission) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      mission.completed ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: mission.completed ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mission.title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                          Text(mission.detail, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _SummaryCard({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiCoachCard extends StatelessWidget {
  final AiCoachMessage message;

  const _AiCoachCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(message.message, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  final List<WeeklyProgressItem> items;

  const _WeeklyProgressCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weekly Progress', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final item in items)
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 90 * item.value,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(item.label, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutHistoryCard extends StatelessWidget {
  final List<WorkoutHistoryEntry> history;

  const _WorkoutHistoryCard({required this.history});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Workout History', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            for (final entry in history)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        entry.date.day.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.workoutType, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('${entry.durationMinutes} min • ${entry.calories} kcal', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Icon(
                      entry.completed ? Icons.check_circle : Icons.pause_circle,
                      color: entry.completed ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
