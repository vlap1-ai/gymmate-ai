import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/firebase_providers.dart';
import 'auth_repository.dart';
import 'models/app_user.dart';

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<AppUser?> {
  late final AuthRepository _repo;
  StreamSubscription<AppUser?>? _sub;

  @override
  FutureOr<AppUser?> build() {
    _repo = ref.read(authRepositoryProvider);
    // start with loading state while listening
    state = const AsyncValue.loading();
    _sub = _repo.authStateChanges().listen((user) {
      state = AsyncValue.data(user);
    }, onError: (err, st) {
      state = AsyncValue.error(err, st);
    });

    ref.onDispose(() {
      _sub?.cancel();
    });

    return null;
  }

  Future<AppUser?> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.signInWithEmailPassword(email, password);
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<AppUser?> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.signUpWithEmailPassword(email, password);
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repo.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _repo.sendPasswordResetEmail(email);
    } catch (e) {
      rethrow;
    }
  }
}
