// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_submit_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSubmitOtpResponseModel _$AuthSubmitOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => AuthSubmitOtpResponseModel(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$AuthSubmitOtpResponseModelToJson(
  AuthSubmitOtpResponseModel instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};
