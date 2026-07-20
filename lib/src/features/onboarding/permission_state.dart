import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health/health.dart';

final onboardingPermissionProvider = NotifierProvider<OnboardingPermissionNotifier, OnboardingPermissionState>(
  OnboardingPermissionNotifier.new,
);

class OnboardingPermissionState {
  final bool locationGranted;
  final bool notificationsGranted;
  final bool healthGranted;

  const OnboardingPermissionState({
    this.locationGranted = false,
    this.notificationsGranted = false,
    this.healthGranted = false,
  });

  bool get allGranted => locationGranted && notificationsGranted && healthGranted;

  OnboardingPermissionState copyWith({
    bool? locationGranted,
    bool? notificationsGranted,
    bool? healthGranted,
  }) {
    return OnboardingPermissionState(
      locationGranted: locationGranted ?? this.locationGranted,
      notificationsGranted: notificationsGranted ?? this.notificationsGranted,
      healthGranted: healthGranted ?? this.healthGranted,
    );
  }
}

class OnboardingPermissionNotifier extends Notifier<OnboardingPermissionState> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final Health _health = Health();

  @override
  OnboardingPermissionState build() => const OnboardingPermissionState();

  Future<void> requestLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(locationGranted: false);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final granted = permission == LocationPermission.always || permission == LocationPermission.whileInUse;
    state = state.copyWith(locationGranted: granted);
  }

  Future<void> requestNotificationPermission() async {
    const initializationSettings = InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
    );

    await _notificationsPlugin.initialize(settings: initializationSettings);

    final darwinImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    final granted = await darwinImpl?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    state = state.copyWith(notificationsGranted: granted);
  }

  Future<void> requestHealthPermission() async {
    await _health.configure();

    final types = <HealthDataType>[
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.HEART_RATE,
      HealthDataType.STEPS,
      HealthDataType.WORKOUT,
      HealthDataType.BODY_MASS_INDEX,
      HealthDataType.BODY_FAT_PERCENTAGE,
    ];

    if (Platform.isIOS) {
      final granted = await _health.requestAuthorization(types);
      state = state.copyWith(healthGranted: granted);
    } else {
      final granted = await _health.requestAuthorization(types);
      state = state.copyWith(healthGranted: granted);
    }
  }

  Future<void> requestAllPermissions() async {
    await requestLocationPermission();
    await requestNotificationPermission();
    await requestHealthPermission();
  }
}
