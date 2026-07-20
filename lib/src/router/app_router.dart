import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/ui/onboarding_permission_screen.dart';
import '../features/onboarding/ui/onboarding_screen.dart';
import '../features/onboarding/ui/weekly_routine_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/permissions',
        builder: (context, state) => const OnboardingPermissionScreen(),
      ),
      GoRoute(
        path: '/weekly',
        builder: (context, state) => const WeeklyRoutineScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
