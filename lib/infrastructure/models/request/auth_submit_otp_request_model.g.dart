// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_submit_otp_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSubmitOtpRequestModel _$AuthSubmitOtpRequestModelFromJson(
  Map<String, dynamic> json,
) => AuthSubmitOtpRequestModel(
  phone: json['phone'] as String,
  otp: json['otp'] as String,
);

Map<String, dynamic> _$AuthSubmitOtpRequestModelToJson(
  AuthSubmitOtpRequestModel instance,
) => <String, dynamic>{'phone': instance.phone, 'otp': instance.otp};
