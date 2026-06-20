import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_user.dart';

/// States emitted by [AuthBloc].
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial — not yet checked.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading — in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated — user logged in.
class AuthAuthenticated extends AuthState {
  final AuthUser user;
  final String token;

  const AuthAuthenticated({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}

/// Unauthenticated — no valid token.
class AuthUnauthenticated extends AuthState {
  final String? phoneHint;

  const AuthUnauthenticated({this.phoneHint});

  @override
  List<Object?> get props => [phoneHint];
}

/// Error state.
class AuthError extends AuthState {
  final String message;
  final String? phone;

  const AuthError({required this.message, this.phone});

  @override
  List<Object?> get props => [message, phone];
}
