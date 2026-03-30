# Aether

**"Your assets, unified."**

Aether is a cross-platform finance and asset management application built with Flutter. It allows users to track their net worth across various asset classes, including cryptocurrencies, stocks, collectibles, and cash, providing a unified view of their financial portfolio.

---

## 🚀 Key Features

- **Portfolio Dashboard**: Visualize your net worth history with interactive charts (powered by `fl_chart`).
- **Asset Tracking**: Categorize and manage diverse assets (Crypto, Stocks, Collectibles, Inventory, Cash).
- **Authentication**: Secure login and registration system.
- **Dynamic Theming**: Support for both Light and Dark modes.
- **Internationalization**: Fully localized in English and Portuguese.
- **Platform-Specific UI**: Customized macOS title bar (blended "traffic lights") with adaptive safe-area padding.

---

## 🏗️ Architecture & Tech Stack

This project follows a **Domain-Driven Design (DDD) / Clean Architecture** pattern to ensure maintainability and testability:

- **State Management**: `flutter_bloc` for predictable UI state.
- **Routing**: `go_router` for declarative navigation and sub-routes (ShellRoute).
- **Dependency Injection**: `get_it` for service location.
- **Storage**: `hive_flutter` for local caching and `flutter_secure_storage` for credentials.
- **Networking**: `dio` for API communication.
- **UI/UX**: `animations` for smooth transitions and `flutter_staggered_grid_view` for responsive layouts.

### Folder Structure
- `lib/data`: Data sources, API models, and repository implementations.
- `lib/domain`: Business logic entities and repository interfaces.
- `lib/logic`: BLoCs and events handling app state.
- `lib/presentation`: Widgets, pages, themes, and navigation.

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (latest stable recommended)
- Dart SDK

### Installation
1. Clone the repository.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate localizations:
   ```bash
   flutter gen-l10n
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## 💻 Desktop Customization (macOS)
The app uses a transparent title bar on macOS for a modern, native look. 
- Custom logic in `macos/Runner/MainFlutterWindow.swift` enables `.fullSizeContentView`.
- Adaptive padding is handled in `lib/presentation/pages/main_scaffold.dart` using `SafeArea.minimum` to prevent window controls from overlapping app content.
