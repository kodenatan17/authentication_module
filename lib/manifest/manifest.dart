import 'package:core_module/core_module.dart';

/// Authentication module manifest metadata.
final ModuleManifest authenticationManifest = ModuleManifest(
  name: 'authentication',
  displayName: 'Authentication',
  version: ModuleVersion(1, 0, 0),
  description: 'Login, registration, OTP verification, and session management',
  minShellVersion: ModuleVersion(1, 0, 0),
  recommendedShellVersion: ModuleVersion(1, 0, 0),

  // ── Init Strategy ─────────────────────────────────
  // Eager: needed at startup for auth redirect guard.
  initializationStrategy: ModuleInitializationStrategy.eager,
  startupBehavior: StartupBehavior.required,

  // ── Default Visibility ────────────────────────────
  defaultEnabled: true,
  defaultVisible: false,

  dependencies: [
    ModuleDependency(
      moduleName: 'core_module',
      minVersion: ModuleVersion(1, 0, 0),
    ),
  ],
);
