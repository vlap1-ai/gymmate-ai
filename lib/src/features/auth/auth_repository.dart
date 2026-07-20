import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'models/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<AppUser?> signInWithEmailPassword(String email, String password);
  Future<AppUser?> signUpWithEmailPassword(String email, String password);
  Future<AppUser?> signInWithApple();
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
  Future<AppUser?> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );

    final oauthCredential = fb.OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken!,
      accessToken: appleCredential.authorizationCode,
    );

    final userCredential = await _auth.signInWithCredential(oauthCredential);
    return userCredential.user == null ? null : AppUser.fromFirebase(userCredential.user!);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }
}
