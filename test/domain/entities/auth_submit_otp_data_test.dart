import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_module/domain/entities/auth_submit_otp_data.dart';

void main() {
  group('AuthSubmitOtpData', () {
    const data = AuthSubmitOtpData(otp: '123456', phoneNumber: '08123456789');

    test('constructor assigns fields', () {
      expect(data.otp, '123456');
      expect(data.phoneNumber, '08123456789');
    });

    test('props correct', () {
      expect(data.props, ['123456', '08123456789']);
    });

    test('equality', () {
      const same = AuthSubmitOtpData(otp: '123456', phoneNumber: '08123456789');
      expect(data, same);

      const diff = AuthSubmitOtpData(otp: '654321', phoneNumber: '08987654321');
      expect(data, isNot(diff));
    });
  });
}
