import 'package:equatable/equatable.dart';

class DoRefreshTokenParams extends Equatable {
  final String accessToken;
  final String refreshToken;

  const DoRefreshTokenParams({
    required this.accessToken,
    required this.refreshToken,
  });
  
  @override
  List<Object?> get props => [accessToken, refreshToken];
}