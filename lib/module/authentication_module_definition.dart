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
class AuthenticationModule extends BaseFeatureModule {
  @override
  String get name => 'authentication';

  @override
  String get displayName => 'Authentication';

  @override
  ModuleVersion get version => ModuleVersion(1, 0, 0);

  @override
  ModuleManifest get manifest => authenticationManifest;

  @override
  void setupDependencies() {
    setupAuthenticationInjection();
  }

  @override
  List<RouteBase> get routes => AuthenticationRoutes.all;
}
