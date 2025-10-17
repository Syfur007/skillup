# SkillUp

A cross-platform Flutter application scaffolded with a feature-first, Clean Architecture-inspired structure.

This repository is a frontend-friendly skeleton intended to help teams build scalable, testable Flutter apps. It separates responsibilities into three layers: Presentation (features), Domain (business logic), and Data (data sources and repository implementations).

Key goals
- Clear feature-first layout to let frontend teams work on UI and state independently.
- Clean Architecture boundaries to make business logic platform-agnostic and easy to test.
- Minimal, runnable placeholder app so the repository can be run immediately.

Features (initial)
- Placeholder homepage and theming
- Project skeleton for features: auth, explore, dashboard, groups, profile
- Domain/usecase/repository stubs and mock data source for frontend-first development

Table of contents
- [Getting started](#getting-started)
- [Prerequisites](#prerequisites)
- [Build for release](#build-for-release)
- [Testing](#testing)
- [Project structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## Getting started

1. Clone the repository

```bash
git clone <your-repo-url>
cd skillup
```

2. Install dependencies

```bash
flutter pub get
```

3. Run the app on an emulator or device

```bash
# Run on the default connected device
flutter run

# List devices
flutter devices

# Run on a specific device
flutter run -d <device-id>
```

## Prerequisites

- Flutter SDK (stable) — see https://docs.flutter.dev/get-started/install
- Android SDK / Android Studio for Android builds
- Xcode for iOS/macOS builds (macOS only)
- Visual Studio for Windows desktop builds (Windows only)
- Development devices or emulators for your target platforms

## Build for release

Android (APK)

```bash
flutter build apk --release
```

Android (App Bundle)

```bash
flutter build appbundle --release
```

iOS (on macOS)

```bash
flutter build ios --release
```

Web

```bash
flutter build web --release
```

macOS

```bash
flutter build macos --release
```

Windows

```bash
flutter build windows --release
```

Linux

```bash
flutter build linux --release
```

## Testing

Run unit and widget tests with:

```bash
flutter test
```

Linting and format

```bash
# Analyze the project
flutter analyze

# Format code
flutter format .
```

## Project structure

- `lib/`
  - `app.dart` — Top-level `MaterialApp` composition, theming and router wiring
  - `main.dart` — Application entrypoint and service initialization
  - `core/` — Shared utilities, theme, navigation, common widgets
  - `data/` — Data sources, DTOs, repository implementations (mock + real)
  - `domain/` — Entities, repository interfaces, use cases
  - `features/` — Presentation layer organized by feature (auth, explore, dashboard, groups, profile)

This project follows a feature-first approach so most active development will occur under `lib/features/` while `lib/domain/` and `lib/data/` provide the plumbing to keep UI decoupled from data sources.

##  Contributing

Contributions are welcome. A few guidelines:
- Open an issue to discuss large changes before implementing them.
- Follow existing code style and prefer small, focused pull requests.
- Add tests for new logic in `domain` or `features` when applicable.

Notes / Next steps

- Replace the placeholder home with `GoRouter` or Navigator 2.0 routes when ready.
- Implement the mock API service to enable frontend-first development without backend dependencies.
- Add CI for tests and static analysis.

## License

This project does not include a license file by default. Add a LICENSE file if you plan to open-source the repository or specify your preferred license here.

Contact

For questions about this scaffold, update requests, or suggestions, open an issue in the repository.
