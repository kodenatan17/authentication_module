import 'package:equatable/equatable.dart';

class AuthSubmitOtpData extends Equatable {
  final String accessToken;
  final String refreshToken;

  const AuthSubmitOtpData({
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [accessToken, refreshToken];
}
