import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/primary_button.dart';
import '../permission_state.dart';

class OnboardingPermissionScreen extends ConsumerStatefulWidget {
  const OnboardingPermissionScreen({super.key});

  @override
  ConsumerState<OnboardingPermissionScreen> createState() => _OnboardingPermissionScreenState();
}

class _OnboardingPermissionScreenState extends ConsumerState<OnboardingPermissionScreen> {
  String _statusLabel(bool granted) => granted ? 'Granted' : 'Pending';

  IconData _statusIcon(bool granted) => granted ? Icons.check_circle : Icons.hourglass_empty;

  @override
  Widget build(BuildContext context) {
    final permissionState = ref.watch(onboardingPermissionProvider);
    final notifier = ref.read(onboardingPermissionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enable the key permissions that power your automatic training journey.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    _PermissionTile(
                      icon: Icons.location_on,
                      title: 'Location access',
                      description: 'Detect your gym entry and exit automatically.',
                      statusLabel: _statusLabel(permissionState.locationGranted),
                      statusIcon: _statusIcon(permissionState.locationGranted),
                      onRequest: notifier.requestLocationPermission,
                    ),
                    const SizedBox(height: 12),
                    _PermissionTile(
                      icon: Icons.notifications,
                      title: 'Notification access',
                      description: 'Receive smart reminders when it’s time to train.',
                      statusLabel: _statusLabel(permissionState.notificationsGranted),
                      statusIcon: _statusIcon(permissionState.notificationsGranted),
                      onRequest: notifier.requestNotificationPermission,
                    ),
                    const SizedBox(height: 12),
                    _PermissionTile(
                      icon: Icons.health_and_safety,
                      title: 'Apple Health access',
                      description: 'Sync workout data for calories, heart rate, and activity.',
                      statusLabel: _statusLabel(permissionState.healthGranted),
                      statusIcon: _statusIcon(permissionState.healthGranted),
                      onRequest: notifier.requestHealthPermission,
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: permissionState.allGranted ? 'Continue to weekly plan' : 'Request all permissions',
                      onPressed: () async {
                        final router = GoRouter.of(context);
                        await notifier.requestAllPermissions();
                        if (!mounted) return;
                        router.go('/weekly');
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => context.go('/weekly'),
                      child: const Text('Skip and continue'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String statusLabel;
  final IconData statusIcon;
  final Future<void> Function() onRequest;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.statusLabel,
    required this.statusIcon,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                ),
                Row(
                  children: [
                    Icon(statusIcon, size: 18, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(statusLabel, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: onRequest,
                child: const Text('Allow'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
