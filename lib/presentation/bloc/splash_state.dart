part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashShouldLoginRegister extends SplashState {}

class SplashAlreadyLoggedIn extends SplashState {
  final String accessToken;
  final String refreshToken;
  final UserProfileData? userProfileData;
  final int agoraId;

  const SplashAlreadyLoggedIn({
    required this.accessToken,
    required this.refreshToken,
    this.userProfileData,
    required this.agoraId,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, userProfileData, agoraId];  
}

class SplashShouldInputUsername extends SplashState {}
