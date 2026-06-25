import 'package:authentication_module/infrastructure/models/request/auth_refresh_token_request_model.dart';
import 'package:authentication_module/infrastructure/models/request/auth_request_otp_request_model.dart';
import 'package:authentication_module/infrastructure/models/request/auth_submit_otp_request_model.dart';
import 'package:authentication_module/infrastructure/models/response/auth_request_otp_response_model.dart';
import 'package:authentication_module/routes/authentication_api.dart';
import 'package:core_module/infrastructure/response/base_success_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/response/auth_refresh_token_response_model.dart';
import '../models/response/auth_submit_otp_response.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST(AuthenticationApi.refreshToken)
  Future<BaseSuccessResponse<AuthRefreshTokenResponseModel>> refreshToken(
    @Body() AuthRefreshTokenRequestModel body,
  );

  @POST(AuthenticationApi.submitOtp)
  Future<BaseSuccessResponse<AuthSubmitOtpResponseModel>> submitOtp(
    @Body() AuthSubmitOtpRequestModel body,
  );

  @POST(AuthenticationApi.requestOtp)
  Future<BaseSuccessResponse<AuthRequestOtpResponseModel>> requestOtp(
    @Body() AuthRequestOtpRequestModel body,
  );
}
