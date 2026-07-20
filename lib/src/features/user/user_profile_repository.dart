import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> fetchProfile(String uid);
  Future<void> saveProfile(UserProfile profile);
  Future<void> updateProfile(String uid, Map<String, Object?> data);
  Stream<UserProfile?> watchProfile(String uid);
}

class FirestoreUserProfileRepository implements UserProfileRepository {
  final FirebaseFirestore _firestore;

  FirestoreUserProfileRepository(this._firestore);

  CollectionReference<UserProfile> get _profiles =>
      _firestore.collection('users').withConverter<UserProfile>(
            fromFirestore: (snapshot, _) => UserProfile.fromMap(snapshot.data()!),
            toFirestore: (profile, _) => profile.toMap(),
          );

  DocumentReference<UserProfile> _profileRef(String uid) {
    return _profiles.doc(uid);
  }

  @override
  Future<UserProfile> fetchProfile(String uid) async {
    final snapshot = await _profileRef(uid).get();
    if (!snapshot.exists || snapshot.data() == null) {
      throw StateError('User profile not found for uid: $uid');
    }
    return snapshot.data()!;
  }

  @override
  Future<void> saveProfile(UserProfile profile) {
    return _profileRef(profile.uid).set(profile);
  }

  @override
  Future<void> updateProfile(String uid, Map<String, Object?> data) {
    return _profileRef(uid).update(data);
  }

  @override
  Stream<UserProfile?> watchProfile(String uid) {
    return _profileRef(uid).snapshots().map((snapshot) => snapshot.data());
  }
}
