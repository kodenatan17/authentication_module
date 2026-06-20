import 'package:go_router/go_router.dart';

/// Route paths owned by the authentication module.
///
/// These routes are registered at shell level (outside the auth guard)
/// because they are public routes, not module routes.
class AuthenticationRoutes {
  static const String login = '/login';
  static const String registerVerify = '/register-verify';

  /// Routes are intentionally empty here because auth routes
  /// are registered directly in the shell's GoRouter config
  /// (before the auth redirect guard).
  ///
  /// See [AuthenticationModule.routes] for details.
  static List<RouteBase> get all => const [];
}
