# Attendly - Cross-Platform Attendance & Operations Tracker

**Attendly** is an enterprise-grade Flutter mobile application engineered for employee attendance tracking and HR operations management with role-based access control (Admin / Employee), real-time location verification, interactive map previews, offline-first SQLite synchronization, and multi-flavor environment configurations.

---

## Technical Stack & Architecture
- **Architecture**: Feature-First Clean Architecture (Data, Domain, Presentation)
- **State Management**: BLoC / Cubit (`flutter_bloc`) with Immutable States (`freezed`)
- **Dependency Injection**: Service Locator Pattern (`get_it` + `injectable`)
- **Navigation**: Declarative Routing (`go_router`) with deep link and state guards
- **Offline Persistence**: Local SQLite Database (`drift` engine) + `shared_preferences`
- **Location & Mapping**: Real-time GPS verification (`geolocator`, `geocoding`) + OpenStreetMap (`flutter_map`)
- **Backend Integration**: Firebase Authentication, Cloud Firestore, and Firebase Storage

---

## Prerequisites
- **Flutter SDK**: `>= 3.0.0 < 4.0.0`
- **Dart SDK**: `>= 3.0.0`
- **Android Studio / VS Code**
- Connected Android/iOS device or emulator

---

## Getting Started

### 1. Installation
Clone the repository and fetch dependencies:

```bash
flutter pub get
```

### 2. Code Generation
Run `build_runner` to generate code for Freezed states, Injectable dependency injection, and Drift SQLite database tables:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Running the Application

This project utilizes multi-environment build flavors (`local`, `staging`, `prod`).

### Run in Debug / Development Mode:
- **Local Flavor**:
  ```bash
  flutter run --flavor local -t lib/main.dart
  ```

- **Staging Flavor**:
  ```bash
  flutter run --flavor staging -t lib/main.dart
  ```

- **Production Flavor**:
  ```bash
  flutter run --flavor prod -t lib/main.dart
  ```

---

## Building Release APKs

To generate standalone release `.apk` files for testing or distribution across environment flavors:

### 1. Local Release APK:
```bash
flutter build apk --flavor local -t lib/main.dart --release
```
*Output*: `build/app/outputs/flutter-apk/app-local-release.apk`

### 2. Staging Release APK:
```bash
flutter build apk --flavor staging -t lib/main.dart --release
```
*Output*: `build/app/outputs/flutter-apk/app-staging-release.apk`

### 3. Production Release APK:
```bash
flutter build apk --flavor prod -t lib/main.dart --release
```
*Output*: `build/app/outputs/flutter-apk/app-prod-release.apk`

---

## Core Features

- **Employee Attendance Suite**:
  - Live greeting header with employee full name and profile avatar.
  - Active check-in state restoration across app restarts.
  - Current reverse-geocoded address, GPS coordinates, and keyless map preview.
  - Large primary Check-In / Check-Out action button.
- **Offline-First Auto-Sync**:
  - Local SQLite persistence when offline.
  - Background network listener with auto-upload on reconnection.
  - Tabbed history view (`Synced` vs `Pending`) with offline sync indicators.
- **Admin Management Suite**:
  - Real-time metrics dashboard (Total Employees, Today's Check-ins, Today's Check-outs).
  - Employee Directory with search and infinite-scroll pagination.
  - System-wide Attendance Logs with employee dropdown and date range filtering.
- **UI / UX Design Systems**:
  - Material 3 theme with Poppins typography (`GoogleFonts.poppins`).
  - Persistent Dark Mode preference saved in local storage.
  - Edge-to-edge transparent system bars and double-tap back press to exit app.
