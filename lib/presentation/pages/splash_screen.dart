import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../injection/authentication_injection.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    getIt<FirebaseAnalyticsHelper>().screenView(
      screenName: 'Splash Screen',
      eventCategory: 'splash',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashCubit>(create: (ctx) => getIt<SplashCubit>()),
        BlocProvider<LogoutBloc>(create: (ctx) => getIt<LogoutBloc>()),
      ],
      child: Scaffold(body: _SplashLayout()),
    );
  }
}

class _SplashLayout extends StatefulWidget {
  @override
  State<_SplashLayout> createState() => __SplashLayoutState();
}

class __SplashLayoutState extends State<_SplashLayout> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // iOS first-launch: wait for ATT + Notification permission dialogs to
      // resolve before starting the splash auto-login flow. On subsequent
      // launches iosPermissionsDone is already completed so this is instant.
      // On Android iosPermissionsDone is completed immediately in MyApp.initState.
      await iosPermissionsDone.future;
      if (mounted) {
        context.read<SplashCubit>().debounceLogo();
      }
    });
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = 'Version ${packageInfo.version}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LogoutBloc, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              context.goNamed(AppRoutes.login);
            }
            if (state is LogoutErrorState) {
              context.read<SplashCubit>().debounceLogo();
            }
          },
        ),
        BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashAlreadyLoggedIn) {
              context.read<UserSessionCubit>().updateUserSession(
                accessToken: state.accessToken,
                refreshToken: state.refreshToken,
                userData: state.userProfileData,
                agoraId: state.agoraId,
              );
              context.goNamed(AppRoutes.home);
            } else if (state is SplashShouldLoginRegister) {
              context.goNamed(AppRoutes.login);
            } else if (state is SplashShouldInputUsername) {
              context.goNamed(AppRoutes.completeProfile);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Assets.images.imgBackground.image(fit: BoxFit.cover),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.icons.icPasconnectLogo.path,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    Assets.icons.icPasconnectText.path,
                    width: 200,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BaseText.bodyMediumRegular(
                      text: '© Arjaya Telindo',
                      textColor: AppColors.primaryText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    BaseText.bodyMediumRegular(
                      text: _version.isEmpty ? 'Loading...' : _version,
                      textColor: AppColors.primaryText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
