import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_module/domain/entities/auth_refresh_token_data.dart';
import 'package:authentication_module/infrastructure/models/response/auth_refresh_token_response_model.dart';

void main() {
  group('AuthRefreshTokenResponseModel', () {
    final json = {
      'accessToken': 'access-123',
      'refreshToken': 'refresh-456',
    };

    test('fromJson creates model', () {
      final model = AuthRefreshTokenResponseModel.fromJson(json);
      expect(model.accessToken, 'access-123');
      expect(model.refreshToken, 'refresh-456');
    });

    test('toJson produces correct map', () {
      final model = AuthRefreshTokenResponseModel(
        accessToken: 'access-123',
        refreshToken: 'refresh-456',
      );
      expect(model.toJson(), json);
    });

    test('toDomain returns AuthRefreshTokenData', () {
      final model = AuthRefreshTokenResponseModel.fromJson(json);
      final data = model.toDomain();
      expect(data, isA<AuthRefreshTokenData>());
      expect(data.accessToken, 'access-123');
      expect(data.refreshToken, 'refresh-456');
    });

    test('toString returns map representation', () {
      final model = AuthRefreshTokenResponseModel(
        accessToken: 'a',
        refreshToken: 'b',
      );
      expect(model.toString(), '{accessToken: a, refreshToken: b}');
    });
  });
}
