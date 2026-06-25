import 'package:authentication_module/application/usecases/refresh_token/do_refresh_token_params.dart';
import 'package:authentication_module/application/usecases/submit_otp/do_submit_otp_params.dart';
import 'package:authentication_module/domain/entities/auth_refresh_token_data.dart';
import 'package:authentication_module/domain/entities/auth_request_otp_data.dart';
import 'package:authentication_module/domain/entities/auth_submit_otp_data.dart';
import 'package:authentication_module/domain/entities/auth_user_token_data.dart';
import 'package:authentication_module/domain/repositories/auth_repository.dart';
import 'package:authentication_module/infrastructure/datasource/auth_remote_datasource.dart';
import 'package:core_module/core_module.dart';
import 'package:injectable/injectable.dart';

/// Implementation of [AuthRepository].
///
/// Delegates data fetching to [AuthRemoteDataSource] and maps
/// response models to domain entities.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final BaseDioErrorHandler _baseDioErrorHandler;
  AuthRepositoryImpl(this._remoteDataSource, this._baseDioErrorHandler);

  @override
  Future<ResultEntity<AuthRefreshTokenData>> refreshToken({
    required DoRefreshTokenParams doRefreshToken,
  }) async {
    try {
      final response = await _remoteDataSource.refreshToken(doRefreshToken);
      return ResultEntity.success(data: response.toDomain());
    } catch (e) {
      return ResultEntity.error(message: e.toString());
    }
  }

  @override
  Future<ResultEntity<AuthRequestOtpData>> requestOtp({required String phone}) {
    // TODO: implement requestOtp
    throw UnimplementedError();
  }

  @override
  Future<ResultEntity<void>> authLogout() {
    // TODO: implement authLogout
    throw UnimplementedError();
  }

  @override
  Future<ResultEntity<AuthUserTokenData>> getCurrentToken() {
    // TODO: implement getCurrentToken
    throw UnimplementedError();
  }

  @override
  Future<ResultEntity<bool>> isLoggedIn() {
    // TODO: implement isLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<ResultEntity<AuthSubmitOtpData>> submitOtp({
    required DoSubmitOtpParams params,
  }) {
    // TODO: implement submitOtp
    throw UnimplementedError();
  }
}
