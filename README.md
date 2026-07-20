## GymMate AI

> The AI Companion That Grows With You.

GymMate AI is an AI-powered fitness companion built with Flutter for iOS.

Instead of manually tracking workouts, GymMate AI automatically follows the user's fitness journey using Apple Health, HealthKit, geofencing, and AI coaching.

---

## Features

- AI Fitness Coach
- Apple Health Integration
- HealthKit Workout Tracking
- Smart Gym Detection
- Mission & Streak System
- Nutrition Recommendation
- Firebase Authentication
- Firestore Cloud Sync
- Dark Mode
- Material 3 Design

---

## Tech Stack

- Flutter
- Riverpod
- GoRouter
- Firebase
- Firestore
- HealthKit
- Apple Health
- OpenAI
- Google Maps
- Geolocator

---

## Architecture

- Clean Architecture
- Repository Pattern
- Dependency Injection
- SOLID Principles
- Feature-first Folder Structure

---

## Roadmap

- [x] Project Foundation
- [x] Onboarding
- [x] Firebase Foundation
- [ ] Authentication
- [ ] User Profile
- [ ] Mission System
- [ ] Apple Health
- [ ] Geofencing
- [ ] AI Coach
- [ ] Nutrition Recommendation
- [ ] TestFlight
- [ ] App Store Release

---

## Current Status

Milestone 2 Completed

- Flutter Foundation
- Onboarding Flow
- Firebase Core + Auth + Firestore foundation
- Clean Architecture
- Navigation
- Material 3

Notes:
- Firebase is initialized at startup via `FirebaseConfig` and environment `--dart-define` values.
- No secrets or API keys are committed — use `--dart-define` or CI secrets for Firebase configuration.

---

## How to run (local dev)

1. Create a local `.env` or run with `flutter run --dart-define` values matching `.env.example`.

Examples:

```bash
# macOS / iOS local run with dart-defines
flutter run \
	--dart-define=FIREBASE_API_KEY=your-api-key \
	--dart-define=FIREBASE_APP_ID=your-app-id \
	--dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id \
	--dart-define=FIREBASE_PROJECT_ID=your-project-id
```

2. Run analyzer and tests:

```bash
flutter analyze
flutter test
```

---

## License

MIT
