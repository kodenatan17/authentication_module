import 'package:go_router/go_router.dart';
import 'package:core_module/core_module.dart';

import '../injection/authentication_injection.dart';
import '../manifest/manifest.dart';
import '../routes/authentication_routes.dart';

/// FeatureModule implementation for the Authentication module.
///
/// Note: Auth routes (/login, /register-verify) are registered directly
/// in the shell's GoRouter config because they sit outside the auth
/// redirect guard. This module's [routes] getter returns an empty list
/// to avoid duplicate registration.
class AuthenticationModule extends FeatureModule {
  bool _initialized = false;

  @override
  String get name => 'authentication';

  @override
  String get displayName => 'Authentication';

  @override
  ModuleVersion get version => ModuleVersion(1, 0, 0);

  @override
  ModuleManifest get manifest => authenticationManifest;

  @override
  bool get isInitialized => _initialized;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
  }

  @override
  void dispose() {
    _initialized = false;
  }

  @override
  void setupDependencies() {
    setupAuthenticationInjection();
  }

  @override
  List<RouteBase> get routes => AuthenticationRoutes.all;
}
