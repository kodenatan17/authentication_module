import 'package:equatable/equatable.dart';

/// Events dispatched to [AuthBloc].
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// User taps Login button.
class LoginSubmitted extends AuthEvent {
  final String phone;
  final String password;

  const LoginSubmitted({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

/// User taps Verify OTP button.
class VerifyOtpSubmitted extends AuthEvent {
  final String phone;
  final String otp;

  const VerifyOtpSubmitted({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}

/// Check stored auth on app start.
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

/// User taps Logout.
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
