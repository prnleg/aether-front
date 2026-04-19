# Aether

**"Your assets, unified."**

Aether is a cross-platform finance and asset management app built with Flutter. Tracks net worth across crypto, stocks, collectibles, inventory, and cash — unified portfolio view across all platforms.

**Version:** 0.5.0 · **Targets:** iOS · Android · macOS · Windows · Linux · Web

---

## Features

- **Portfolio Dashboard** — Net worth history with interactive charts (`fl_chart`), optional header layout.
- **Asset Management** — Add, view, and delete assets across Crypto, Stocks, Collectibles, Inventory, and Cash categories.
- **Discovery Hub** — Browse and search market assets.
- **Secure Authentication** — JWT-based login/registration with token persistence via `flutter_secure_storage`.
- **Biometric Lock** — Re-authenticate on app resume with `local_auth`; respects background/foreground transitions.
- **Settings** — Theme (light/dark), locale (EN/PT), currency, and biometrics toggles — persisted via Hive.
- **Skeleton Loading** — Shimmer skeletons on assets, account, and discovery pages.
- **Dynamic Theming** — Light and dark mode.
- **Internationalization** — English and Portuguese.
- **macOS Title Bar** — Transparent blended title bar with adaptive safe-area padding for window controls.

---

## Architecture

Clean Architecture / DDD. Dependency rule: `presentation` → `logic` → `domain` ← `data`.

```
lib/
├── core/           # Config, exceptions, network (Dio + interceptors), services
├── data/           # DTOs, data sources, repository implementations
├── domain/         # Entities, repository interfaces, use cases
├── logic/          # BLoCs (events, states)
├── presentation/   # Pages, widgets, theme, router
└── service_locator.dart   # GetIt DI wiring
```

### Key Tech

| Concern | Package |
|---|---|
| State management | `flutter_bloc` |
| Routing | `go_router` (ShellRoute + auth redirect) |
| DI | `get_it` |
| Local storage | `hive_flutter` |
| Secure storage | `flutter_secure_storage` |
| Networking | `dio` |
| Biometrics | `local_auth` |
| Charts | `fl_chart` |
| Icons | `font_awesome_flutter` |
| Animations | `animations`, `shimmer` |

### BLoC Convention

- **Global singletons** (registered in `service_locator.dart`): `AuthBloc`, `SettingsBloc`, `AccountBloc` — provided at root in `main.dart`.
- **Page-scoped factories**: `DashboardBloc`, `DiscoveryBloc`, `PlaygroundBloc` — provided per-route in `app_router.dart`.

### Network Layer

`ApiClient` wraps Dio. Base URL set via `--dart-define=BASE_URL=...` (default: `http://localhost:5066`).  
`AuthInterceptor` attaches JWT. `TokenStorage` persists tokens in secure storage.

### Exception Handling

Typed subclasses of `AppException`: `NetworkException`, `AuthException`, `NotFoundException`, `ValidationException`, `UnknownException`.

---

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK `^3.5.4`

### Setup

```bash
# Install dependencies
flutter pub get

# Regenerate localizations (after editing .arb files)
flutter gen-l10n

# Run (default backend: http://localhost:5066)
flutter run

# Run with custom API
flutter run --dart-define=BASE_URL=https://api.yourapp.com
```

### Clean

```bash
flutter clean
```

---

## Localization

ARB files: `lib/l10n/app_en.arb`, `lib/l10n/app_pt.arb`.  
Run `flutter gen-l10n` after any ARB edit to regenerate `lib/l10n/app_localizations*.dart`.

---

## Platform Notes

### macOS

- Transparent title bar via `macos/Runner/MainFlutterWindow.swift` (`.fullSizeContentView`).
- Window controls padding via `SafeArea.minimum` in `lib/presentation/pages/main_scaffold.dart`.
- Biometric and network entitlements in `macos/Runner/DebugProfile.entitlements` and `Release.entitlements`.
