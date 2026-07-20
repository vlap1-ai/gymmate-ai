import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/firebase_providers.dart';
import 'models/user_profile.dart';
import 'user_profile_repository.dart';

final userProfileStreamProvider = StreamProvider.family<UserProfile?, String>((ref, uid) {
  return ref.read(userProfileRepositoryProvider).watchProfile(uid);
});

final userProfileActionProvider = Provider<UserProfileActions>((ref) {
  return UserProfileActions(ref.read(userProfileRepositoryProvider));
});

class UserProfileActions {
  final UserProfileRepository _repository;

  UserProfileActions(this._repository);

  Future<void> saveProfile(UserProfile profile) {
    return _repository.saveProfile(profile);
  }

  Future<void> updateProfile(String uid, Map<String, Object?> data) {
    return _repository.updateProfile(uid, data);
  }
}
