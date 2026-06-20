import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../application/repositories/auth_repository_impl.dart';
import '../application/services/auth_service.dart';
import '../domain/repositories/auth_repository.dart';
import '../infrastructure/datasource/auth_remote_datasource.dart';
import '../presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

/// Register all authentication dependencies into GetIt.
///
/// Call once during app bootstrap after core dependencies are registered.
void setupAuthenticationInjection() {
  // Dio already registered by core_module — reuse it.
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<AuthRepository>()),
  );
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authService: getIt<AuthService>()),
  );
}
