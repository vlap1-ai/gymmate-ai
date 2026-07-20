import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/home_dashboard_models.dart';
import 'repositories/home_dashboard_repository.dart';

final homeDashboardRepositoryProvider = Provider<HomeDashboardRepository>(
  (ref) => LocalHomeDashboardRepository(),
);

final homeDashboardProvider = AsyncNotifierProvider<HomeDashboardNotifier, HomeDashboardState>(
  HomeDashboardNotifier.new,
);

class HomeDashboardNotifier extends AsyncNotifier<HomeDashboardState> {
  late final HomeDashboardRepository _repository;

  @override
  Future<HomeDashboardState> build() async {
    _repository = ref.read(homeDashboardRepositoryProvider);
    return _repository.fetchDashboardState();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchDashboardState());
  }
}
