import 'package:core_module/infrastructure/response/remote_response_mapper.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/auth_request_otp_data.dart';

part 'auth_request_otp_response_model.g.dart';

@JsonSerializable()
class AuthRequestOtpResponseModel implements ResponseMapper<AuthRequestOtpData> {
  final String token;

  AuthRequestOtpResponseModel({required this.token});

  factory AuthRequestOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestOtpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRequestOtpResponseModelToJson(this);

  @override
  String toString() => toJson().toString();

  @override
  AuthRequestOtpData toDomain() {
    return AuthRequestOtpData(token: token);
  }
}
