import 'package:authentication_module/application/usecases/refresh_token/do_refresh_token_params.dart';
import 'package:authentication_module/application/usecases/request_otp/do_request_otp_params.dart';
import 'package:authentication_module/application/usecases/submit_otp/do_submit_otp_params.dart';
import 'package:authentication_module/domain/entities/auth_refresh_token_data.dart';
import 'package:authentication_module/domain/entities/auth_request_otp_data.dart';
import 'package:authentication_module/domain/entities/auth_submit_otp_data.dart';
import 'package:authentication_module/domain/entities/auth_user_token_data.dart';
import 'package:core_module/domain/entities/base_result_entities.dart';

/// Authentication repository contract.
abstract class AuthRepository {
  Future<ResultEntity<AuthRefreshTokenData>> refreshToken({
    DoRefreshTokenParams doRefreshToken,
  });

  Future<ResultEntity<AuthRequestOtpData>> requestOtp({
    DoRequestOtpParams params,
  });

  Future<ResultEntity<AuthSubmitOtpData>> submitOtp({
    required DoSubmitOtpParams params,
  });

  Future<ResultEntity<bool>> isLoggedIn();

  Future<ResultEntity<void>> authLogout();

  Future<ResultEntity<AuthUserTokenData>> getCurrentToken();
}
