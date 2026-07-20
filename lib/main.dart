import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';
import 'src/config/firebase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await FirebaseConfig.initializeFirebase();
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error');
    debugPrint('$stackTrace');
  }

  runApp(const ProviderScope(child: GymMateApp()));
}
