import 'package:equatable/equatable.dart';

class AuthRefreshTokenData extends Equatable {
  final String accessToken;
  final String refreshToken;

  const AuthRefreshTokenData({required this.accessToken, required this.refreshToken});

  @override
  List<Object> get props => [accessToken, refreshToken];
}
