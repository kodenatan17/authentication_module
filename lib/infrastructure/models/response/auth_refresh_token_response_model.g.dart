// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_refresh_token_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRefreshTokenResponseModel _$AuthRefreshTokenResponseModelFromJson(
  Map<String, dynamic> json,
) => AuthRefreshTokenResponseModel(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$AuthRefreshTokenResponseModelToJson(
  AuthRefreshTokenResponseModel instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};
