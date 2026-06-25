import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_module/domain/entities/auth_request_otp_data.dart';

void main() {
  group('AuthRequestOtpData', () {
    test('with token', () {
      const data = AuthRequestOtpData(token: 'some-token');
      expect(data.token, 'some-token');
      expect(data.props, ['some-token']);
    });

    test('token can be null', () {
      const data = AuthRequestOtpData();
      expect(data.token, null);
      expect(data.props, [null]);
    });

    test('equality', () {
      const a = AuthRequestOtpData(token: 'x');
      const b = AuthRequestOtpData(token: 'x');
      const c = AuthRequestOtpData();
      expect(a, b);
      expect(a, isNot(c));
    });
  });
}
