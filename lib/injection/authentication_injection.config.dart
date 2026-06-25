// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../application/services/auth_service.dart' as _i1067;
import '../domain/repositories/auth_repository.dart' as _i800;
import '../infrastructure/datasource/auth_remote_datasource.dart' as _i378;
import '../infrastructure/repositories/auth_repository_impl.dart' as _i43;
import '../infrastructure/services/auth_api_service.dart' as _i821;
import '../presentation/bloc/auth_bloc.dart' as _i244;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt initAuthModule({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i378.AuthRemoteDataSource>(
      () => _i378.AuthRemoteDataSourceImpl(gh<_i821.AuthApiService>()),
    );
    gh.lazySingleton<_i800.AuthRepository>(
      () => _i43.AuthRepositoryImpl(gh<_i378.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i1067.AuthService>(
      () => _i1067.AuthService(gh<_i800.AuthRepository>()),
    );
    gh.factory<_i244.AuthBloc>(
      () => _i244.AuthBloc(authService: gh<_i1067.AuthService>()),
    );
    return this;
  }
}
