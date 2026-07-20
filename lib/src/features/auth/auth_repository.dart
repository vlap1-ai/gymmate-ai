import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'models/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<AppUser?> signInWithEmailPassword(String email, String password);
  Future<AppUser?> signUpWithEmailPassword(String email, String password);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
}

class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _auth;

  FirebaseAuthRepository(this._auth);

  @override
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map((user) => user == null ? null : AppUser.fromFirebase(user));
  }

  @override
  Future<AppUser?> signInWithEmailPassword(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    return credential.user == null ? null : AppUser.fromFirebase(credential.user!);
  }

  @override
  Future<AppUser?> signUpWithEmailPassword(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    return credential.user == null ? null : AppUser.fromFirebase(credential.user!);
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }
}
