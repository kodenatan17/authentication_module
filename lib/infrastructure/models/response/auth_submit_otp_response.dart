import 'package:core_module/infrastructure/response/remote_response_mapper.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/auth_submit_otp_data.dart';

part 'auth_submit_otp_response.g.dart';

@JsonSerializable()
class AuthSubmitOtpResponseModel implements ResponseMapper<AuthSubmitOtpData> {
  final String accessToken;
  final String refreshToken;

  AuthSubmitOtpResponseModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthSubmitOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthSubmitOtpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthSubmitOtpResponseModelToJson(this);

  @override
  AuthSubmitOtpData toDomain() {
    return AuthSubmitOtpData(accessToken: accessToken, refreshToken: refreshToken);
  }

  @override
  String toString() => toJson().toString();
}
