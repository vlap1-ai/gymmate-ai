class Environment {
  static const firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY', defaultValue: '');
  static const firebaseAppId = String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '');
  static const firebaseMessagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '');
  static const firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: '');
  static const firebaseAuthDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: '');
  static const firebaseStorageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: '');
  static const firebaseMeasurementId = String.fromEnvironment('FIREBASE_MEASUREMENT_ID', defaultValue: '');
  static const firebaseDatabaseURL = String.fromEnvironment('FIREBASE_DATABASE_URL', defaultValue: '');

  static bool get hasFirebaseOptions {
    return firebaseApiKey.isNotEmpty &&
        firebaseAppId.isNotEmpty &&
        firebaseMessagingSenderId.isNotEmpty &&
        firebaseProjectId.isNotEmpty;
  }
}
