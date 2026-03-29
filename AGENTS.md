# AGENTS.md - Aether Frontend

This document provides guidance for agentic coding assistants working in this repository.

## Project Overview

**Aether** is a Flutter mobile application for tracking personal assets and net worth across multiple categories (crypto, stocks, inventory, collectibles, cash).

### Architecture

Clean Architecture with BLoC pattern:
```
lib/
├── data/                    # Data layer
│   ├── datasources/         # Remote/local data sources
│   └── repositories/        # Repository implementations
├── domain/                  # Domain layer
│   ├── models/             # Data models (Asset, User, etc.)
│   └── repositories/       # Repository interfaces
├── logic/                   # Business logic
│   └── blocs/              # BLoC state management
│       ├── auth/
│       ├── dashboard/
│       ├── account/
│       └── settings/
├── presentation/           # UI layer
│   ├── pages/              # Screen widgets
│   ├── widgets/             # Reusable components
│   ├── router/             # Navigation (go_router)
│   └── theme/              # App theming
├── l10n/                    # Localization
├── main.dart
└── service_locator.dart     # Dependency injection (get_it)
```

---

## Build/Lint/Test Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Analyze code for errors and warnings
flutter analyze

# Run all tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage

# Build for iOS
flutter build ios

# Build for Android
flutter build apk

# Build release
flutter build apk --release
```

---

## Code Style Guidelines

### General

- Use **2 spaces** for indentation (default Dart convention)
- Use `const` constructors wherever possible
- Avoid `var` when type is known; prefer explicit types
- Use trailing commas for better diffs and formatting

### Imports

```dart
// Package imports first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Then relative imports (use path aliases for clarity)
import 'package:aether/l10n/app_localizations.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import '../../domain/models/asset_model.dart';

// External packages
import 'package:fl_chart/fl_chart.dart';
```

### File Naming

- Dart files: `snake_case.dart`
- BLoC files: `name_bloc.dart`, `name_event.dart`, `name_state.dart`
- Page files: `name_page.dart`
- Widget files: `name_widget.dart` or descriptive names like `net_worth_graph.dart`

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Classes | PascalCase | `class AuthBloc` |
| Files | snake_case | `auth_bloc.dart` |
| Variables | lowerCamelCase | `isLoading`, `totalNetWorth` |
| Private members | prefix `_` | `_authRepository` |
| Constants | camelCase | `primaryColor` |
| Enum values | camelCase | `AssetType.crypto` |
| Boolean vars | prefix `is`/`has`/`can` | `isLoading`, `hasError` |

### State Classes (Equatable)

```dart
class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [status, user, isLoading, error];

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,  // Note: nullable fields should not use ?? this.field
    );
  }
}
```

### Event Classes

```dart
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}
```

### BLoC Pattern

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    // Handle event and emit new state
  }
}
```

### Model Classes

```dart
class Asset extends Equatable {
  final String id;
  final String name;
  final double value;
  final AssetType type;

  const Asset({
    required this.id,
    required this.name,
    required this.value,
    required this.type,
  });

  // Immutable update
  Asset copyWith({...}) {...}

  // JSON serialization
  factory Asset.fromJson(Map<String, dynamic> json) => Asset(...);
  Map<String, dynamic> toJson() => {...};
}
```

### Error Handling

- Use try-catch in BLoC handlers
- Emit error states with user-friendly messages
- Never expose raw exceptions to UI

```dart
Future<void> _onLoginRequested(
  LoginRequested event,
  Emitter<AuthState> emit,
) async {
  emit(state.copyWith(isLoading: true, error: null));
  try {
    await _authRepository.login(event.email, event.password);
    add(AuthStatusChanged());
  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      error: 'Login failed. Please check your credentials.',
    ));
  }
}
```

### UI Components

- Use `BlocBuilder` for reactive UI
- Use `BlocListener` for side effects (navigation, snackbars)
- Use `const` constructors for widgets where possible
- Access localizations: `final l10n = AppLocalizations.of(context)!`

```dart
// Build widgets
return BlocBuilder<DashboardBloc, DashboardState>(
  builder: (context, state) {
    if (state is DashboardLoading) {
      return const DashboardSkeleton();
    } else if (state is DashboardLoaded) {
      return _buildContent(context, state);
    } else if (state is DashboardError) {
      return Center(child: Text(state.message));
    }
    return const SizedBox.shrink();
  },
);
```

### Material 3

- Use `useMaterial3: true` in ThemeData
- Prefer Material 3 components
- Use `ColorScheme.fromSeed()` for consistent theming

---

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `equatable` | Value equality for states/models |
| `get_it` | Dependency injection |
| `go_router` | Declarative routing |
| `dio` | HTTP client |
| `hive_flutter` | Local storage |
| `fl_chart` | Charts |
| `flutter_secure_storage` | Secure storage for tokens |

---

## Linting

The project uses `flutter_lints` with default rules. Run `flutter analyze` to check for issues.

### Common Rules
- Enable `prefer_const_constructors`
- Enable `prefer_const_literals_to_create_immutables`
- Use `avoid_print` in production code
