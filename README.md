# flutter-habit-tracker (Mobile App)

A simple, polished **Flutter** mobile app you can run on Android/iOS that demonstrates:
- Material 3 UI
- CRUD for habits
- Local persistence using `shared_preferences`
- Small, clean architecture (`models/`, `storage/`, `screens/`, `widgets/`)

## Demo features
- Add habit (name + optional goal per week)
- Tap to mark habit **done/not done for today**
- Simple **streak** counter
- Delete habit
- Data persists between launches

## Prerequisites
- Flutter SDK (3.16+ recommended)
- Android Studio / Xcode (for emulators) or a physical device

Verify:
```bash
flutter --version
flutter doctor
```

## Run
```bash
cd flutter-habit-tracker
flutter pub get
flutter run
```

## Build release artifacts
Android:
```bash
flutter build apk --release
# or App Bundle:
flutter build appbundle --release
```

iOS (macOS only):
```bash
flutter build ios --release
```

## Project structure
- `lib/models/` – data models
- `lib/storage/` – local persistence (SharedPreferences)
- `lib/screens/` – screens
- `lib/widgets/` – reusable widgets
- `lib/utils/` – small helpers

## Ideas to extend
- Calendar view / history
- Local notifications (reminders)
- Export/import JSON
- Replace shared_preferences with SQLite (Drift)
## GitHub Actions (CI)
This repo includes a workflow at `.github/workflows/flutter-ci.yml` that runs on pushes and PRs:
- `dart format --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`

## App icon + splash screen
This project is pre-configured with:
- **App icon** via `flutter_launcher_icons`
- **Native splash** via `flutter_native_splash`

### Generate icon + splash (one-time)
1) Add/generate platform folders if you don’t have them yet (optional but recommended):
```bash
flutter create .
```

2) Generate icons:
```bash
dart run flutter_launcher_icons
```

3) Generate splash screens:
```bash
dart run flutter_native_splash:create
```

Assets live in:
- `assets/icon/icon.png`
- `assets/splash/splash.png`

Tip: Replace those PNGs with your own brand logo to match Hexonix.
