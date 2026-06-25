import 'package:core_module/infrastructure/response/remote_response_mapper.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/auth_refresh_token_data.dart';

part 'auth_refresh_token_response_model.g.dart';

@JsonSerializable()
class AuthRefreshTokenResponseModel implements ResponseMapper<AuthRefreshTokenData> {
  final String accessToken;
  final String refreshToken;

  AuthRefreshTokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthRefreshTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthRefreshTokenResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRefreshTokenResponseModelToJson(this);

  @override
  AuthRefreshTokenData toDomain() {
    return AuthRefreshTokenData(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  String toString() => toJson().toString();
}