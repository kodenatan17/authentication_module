import 'package:json_annotation/json_annotation.dart';

part 'auth_request_otp_request_model.g.dart';

@JsonSerializable()
class AuthRequestOtpRequestModel {
  final String phone;

  const AuthRequestOtpRequestModel({required this.phone});

  factory AuthRequestOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestOtpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRequestOtpRequestModelToJson(this);
}
