import 'package:firebase_core/firebase_core.dart';

import 'environment.dart';

class FirebaseConfig {
  static Future<FirebaseApp> initializeFirebase() {
    if (Environment.hasFirebaseOptions) {
      return Firebase.initializeApp(options: _firebaseOptions);
    }

    return Firebase.initializeApp();
  }

  static FirebaseOptions get _firebaseOptions {
    return FirebaseOptions(
      apiKey: Environment.firebaseApiKey,
      appId: Environment.firebaseAppId,
      messagingSenderId: Environment.firebaseMessagingSenderId,
      projectId: Environment.firebaseProjectId,
      authDomain: Environment.firebaseAuthDomain.isNotEmpty ? Environment.firebaseAuthDomain : null,
      storageBucket: Environment.firebaseStorageBucket.isNotEmpty ? Environment.firebaseStorageBucket : null,
      measurementId: Environment.firebaseMeasurementId.isNotEmpty ? Environment.firebaseMeasurementId : null,
      databaseURL: Environment.firebaseDatabaseURL.isNotEmpty ? Environment.firebaseDatabaseURL : null,
    );
  }
}
