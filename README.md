# Authentication Module

Standalone feature module for authentication in the RT-RW Digital system.
Implements the `FeatureModule` contract from `core_module` — self-describing, self-registering, with own DI.

Extracted from the original `resident_module` to allow auth to be developed and maintained independently of resident management.

---

## Package Structure

```
lib/
├── authentication_module.dart                # Barrel exports
├── public_api.dart                           # Domain abstractions (entities, repos)
├── manifest/
│   └── manifest.dart                         # ModuleManifest (eager, required)
├── module/
│   └── authentication_module_definition.dart # FeatureModule implementation
├── domain/
│   ├── entities/
│   │   ├── auth_user.dart                    # Authenticated user entity
│   │   └── auth_result.dart                  # Auth response (token + user)
│   └── repositories/
│       └── auth_repository.dart              # Abstract auth contract
├── application/
│   ├── repositories/
│   │   └── auth_repository_impl.dart         # Auth impl (Dio API + Hive token storage)
│   └── services/
│       └── auth_service.dart                 # High-level auth wrapper
├── infrastructure/
│   ├── datasource/
│   │   └── auth_remote_datasource.dart       # Dio-based auth API calls
│   └── models/
│       ├── auth_response_model.dart          # AuthResponse JSON model
│       └── user_model.dart                   # User JSON model
├── injection/
│   └── authentication_injection.dart         # DI setup (AuthBloc, AuthService, etc.)
├── routes/
│   └── authentication_routes.dart            # Route path constants
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart                    # Auth business logic
    │   ├── auth_event.dart                   # Events: LoginSubmitted, VerifyOtpSubmitted, etc.
    │   └── auth_state.dart                   # States: Initial, Loading, Authenticated, etc.
    └── pages/
        ├── login_page.dart                   # Login screen (phone + password)
        └── otp_verification_page.dart         # OTP verification screen
```

---

## Manifest

Declared in `lib/manifest/manifest.dart`:

| Field                      | Value                                      |
|----------------------------|--------------------------------------------|
| `name`                     | `"authentication"`                         |
| `displayName`              | `"Authentication"`                         |
| `version`                  | `1.0.0`                                    |
| `description`              | Login, registration, OTP verification, and session management |
| `minShellVersion`          | `1.0.0`                                    |
| `initializationStrategy`   | `ModuleInitializationStrategy.eager`       |
| `startupBehavior`          | `StartupBehavior.required`                 |
| `defaultEnabled`           | `true`                                     |
| `defaultVisible`           | `false`                                    |
| Dependencies               | `core_module ^1.0.0`                       |
| Provides                   | `auth.login`, `auth.verify`, `auth.session` |

---

## Authentication

### Auth Domain

```dart
// domain/entities/auth_user.dart
class AuthUser {
  final int id;
  final String name;
  final String phone;
  final String avatar;
}

// domain/entities/auth_result.dart
class AuthResult {
  final bool success;
  final String token;
  final AuthUser user;
}

// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<AuthResult> login({required String phone, required String password});
  Future<AuthResult> verifyOtp({required String phone, required String otp});
  bool get isAuthenticated;
  String? get token;
  Future<void> logout();
}
```

### Auth Flow

```
┌──────────┐     ┌──────────────┐     ┌─────────────────┐
│ LoginPage │────▶│   AuthBloc    │────▶│ AuthService      │
│           │     │              │     │                  │
│ phone +   │     │ LoginSubmitted│     │ AuthRepository   │
│ password  │     │ VerifyOtp     │     │                  │
└──────────┘     └──────┬───────┘     └────────┬─────────┘
                        │                      │
                        │ emit                 │ calls
                  ┌─────▼──────┐      ┌────────▼─────────┐
                  │ AuthState   │      │ AuthRemoteDS      │
                  │             │      │ (Dio)             │
                  │ Authenticated│     │                  │
                  │ Unauthenticated│   │ /auth/login       │
                  │ Error       │      │ /auth/register/verify
                  └────────────┘      └──────────────────┘
```

### Token Storage

`AuthRepositoryImpl` uses Hive to persist the access token:

```
Hive box: 'resident_auth'
  ├── access_token  → String
```

On app start, `AuthBloc` checks `AuthService.isAuthenticated` (reads Hive).
On login/verify success, token is saved to Hive.
On logout, token is deleted from Hive.

### API Endpoints

| Method | Endpoint                | Request                          | Response        |
|--------|-------------------------|----------------------------------|-----------------|
| POST   | `/auth/login`           | `{phone, password}`              | `AuthResponse`  |
| POST   | `/auth/register/verify` | `{phone, otp}`                   | `AuthResponse`  |

`AuthResponse`:
```json
{
  "success": true,
  "token": "jwt-token-here",
  "user": {
    "id": 1,
    "name": "Budi Santoso",
    "phone": "08123456789",
    "avatar": ""
  }
}
```

---

## Routes

Auth routes are registered by the shell (`rt-rw-digital/main.dart`) **outside** the ShellRoute:

```dart
/login                 → LoginPage              (no nav drawer)
/register-verify       → OtpVerificationPage    (no nav drawer)
```

These routes are placed before the auth redirect guard, so unauthenticated users can access them.
`AuthenticationRoutes.all` returns an empty list to avoid duplicate registration in the shell's auto-route composition.

---

## Initialization

The authentication module is initialized **eagerly** during app startup — the shell needs `AuthBloc` for the route redirect guard.

### Bootstrap Participation

```
AppBootstrap.run()
  ↓
Register All Modules          → AuthenticationModule registered
  ↓
Load Cached Feature Flags     → check authentication.enabled
  ↓
DI Setup                      → setupAuthenticationInjection() called
  ↓
Init Eager Modules             → AuthenticationModule.initialize() called
  ↓
App Ready ✅
```

### DI Registration

`setupAuthenticationInjection()` registers the following in GetIt:

| Type                    | Scope            | Depends On            |
|-------------------------|------------------|-----------------------|
| `AuthRemoteDataSource`  | LazySingleton    | `Dio` (from core)     |
| `AuthRepository`        | LazySingleton    | `AuthRemoteDataSource`|
| `AuthService`           | LazySingleton    | `AuthRepository`      |
| `AuthBloc`              | Factory          | `AuthService`         |

---

## Module Definition

`lib/module/authentication_module_definition.dart` implements `FeatureModule`:

| Override              | Implementation                                   |
|-----------------------|--------------------------------------------------|
| `name`                | `"authentication"`                               |
| `displayName`         | `"Authentication"`                               |
| `version`             | `ModuleVersion(1, 0, 0)`                         |
| `manifest`            | `authenticationManifest`                         |
| `isInitialized`       | Returns `_initialized` flag                      |
| `initialize()`        | Sets `_initialized = true` (extendable)          |
| `dispose()`           | Resets `_initialized = false`                    |
| `setupDependencies()` | Calls `setupAuthenticationInjection()`           |
| `routes`              | `AuthenticationRoutes.all` (empty — shell-owned) |

---

## Dependencies

| Package           | Purpose                     |
|-------------------|-----------------------------|
| `core_module`     | Contracts, base classes, Dio|
| `flutter_bloc`    | State management            |
| `go_router`       | Routing                     |
| `get_it`          | DI                          |
| `dio`             | HTTP client                 |
| `hive`            | Local token storage         |
| `equatable`       | Value equality              |

---

## Usage in Shell

```dart
// rt-rw-digital/lib/main.dart

import 'package:authentication_module/authentication_module.dart';
import 'package:authentication_module/presentation/bloc/auth_bloc.dart';
import 'package:authentication_module/presentation/bloc/auth_event.dart';
import 'package:authentication_module/presentation/bloc/auth_state.dart';
import 'package:authentication_module/presentation/pages/login_page.dart';

final modules = <FeatureModule>[
  AuthenticationModule(),   // must be first (eager, required)
  ResidentModule(),
];

// AuthBloc accessed via GetIt after bootstrap
final authBloc = getIt<AuthBloc>();

// Route guard
String? authRedirect(context, state) {
  final isAuthRoute = state.matchedLocation == '/login';
  final isAuthenticated = authBloc.state is AuthAuthenticated;
  if (!isAuthenticated && !isAuthRoute) return '/login';
  if (isAuthenticated && isAuthRoute) return '/';
  return null;
}
```
