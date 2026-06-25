import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_module/domain/entities/auth_refresh_token_data.dart';

void main() {
  group('AuthRefreshTokenData', () {
    const data = AuthRefreshTokenData(
      accessToken: 'access-123',
      refreshToken: 'refresh-456',
    );

    test('constructor assigns fields', () {
      expect(data.accessToken, 'access-123');
      expect(data.refreshToken, 'refresh-456');
    });

    test('props correct', () {
      expect(data.props, ['access-123', 'refresh-456']);
    });

    test('equality', () {
      const same = AuthRefreshTokenData(
        accessToken: 'access-123',
        refreshToken: 'refresh-456',
      );
      expect(data, same);

      const diff = AuthRefreshTokenData(
        accessToken: 'other',
        refreshToken: 'other',
      );
      expect(data, isNot(diff));
    });
  });
}
