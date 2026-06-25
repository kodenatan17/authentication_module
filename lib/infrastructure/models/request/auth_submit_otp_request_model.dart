import 'package:json_annotation/json_annotation.dart';

part 'auth_submit_otp_request_model.g.dart';

@JsonSerializable()
class AuthSubmitOtpRequestModel {
  final String phone;
  final String otp;

  const AuthSubmitOtpRequestModel({required this.phone, required this.otp});

  factory AuthSubmitOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AuthSubmitOtpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthSubmitOtpRequestModelToJson(this);
}
