import 'package:authentication_module/application/usecases/refresh_token/do_refresh_token_params.dart';
import 'package:authentication_module/application/usecases/request_otp/do_request_otp_params.dart';
import 'package:authentication_module/application/usecases/submit_otp/do_submit_otp_params.dart';
import 'package:authentication_module/infrastructure/models/request/auth_refresh_token_request_model.dart';
import 'package:authentication_module/infrastructure/models/request/auth_request_otp_request_model.dart';
import 'package:authentication_module/infrastructure/models/request/auth_submit_otp_request_model.dart';
import 'package:authentication_module/infrastructure/models/response/auth_refresh_token_response_model.dart';
import 'package:authentication_module/infrastructure/models/response/auth_request_otp_response_model.dart';
import 'package:authentication_module/infrastructure/models/response/auth_submit_otp_response.dart';
import 'package:authentication_module/infrastructure/services/auth_api_service.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Future<AuthRefreshTokenResponseModel> refreshToken(
    DoRefreshTokenParams params,
  );

  Future<AuthSubmitOtpResponseModel> submitOtp(DoSubmitOtpParams params);

  Future<AuthRequestOtpResponseModel> requestOtp(DoRequestOtpParams params);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService _authApiService;

  AuthRemoteDataSourceImpl(this._authApiService);

  @override
  Future<AuthRefreshTokenResponseModel> refreshToken(
    DoRefreshTokenParams params,
  ) async {
    final response = await _authApiService.refreshToken(
      AuthRefreshTokenRequestModel(refreshToken: params.refreshToken),
    );
    return response.data;
  }

  @override
  Future<AuthSubmitOtpResponseModel> submitOtp(DoSubmitOtpParams params) async {
    final response = await _authApiService.submitOtp(
      AuthSubmitOtpRequestModel(phone: params.phone, otp: params.otp),
    );
    return response.data;
  }

  @override
  Future<AuthRequestOtpResponseModel> requestOtp(
    DoRequestOtpParams params,
  ) async {
    final response = await _authApiService.requestOtp(
      AuthRequestOtpRequestModel(phone: params.phone),
    );
    return response.data;
  }
}
