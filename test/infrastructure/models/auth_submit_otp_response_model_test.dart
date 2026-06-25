import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_module/domain/entities/auth_submit_otp_data.dart';
import 'package:authentication_module/infrastructure/models/response/auth_submit_otp_response.dart';

void main() {
  group('AuthSubmitOtpResponseModel', () {
    final json = {
      'otp': '123456',
      'phoneNumber': '08123456789',
    };

    test('fromJson creates model', () {
      final model = AuthSubmitOtpResponseModel.fromJson(json);
      expect(model.otp, '123456');
      expect(model.phoneNumber, '08123456789');
    });

    test('toJson produces correct map', () {
      final model = AuthSubmitOtpResponseModel(
        otp: '123456',
        phoneNumber: '08123456789',
      );
      expect(model.toJson(), json);
    });

    test('toDomain returns AuthSubmitOtpData', () {
      final model = AuthSubmitOtpResponseModel.fromJson(json);
      final data = model.toDomain();
      expect(data, isA<AuthSubmitOtpData>());
      expect(data.otp, '123456');
      expect(data.phoneNumber, '08123456789');
    });

    test('toString returns map representation', () {
      final model = AuthSubmitOtpResponseModel(otp: '1', phoneNumber: '2');
      expect(model.toString(), '{otp: 1, phoneNumber: 2}');
    });
  });
}
