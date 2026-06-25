import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_module/domain/entities/auth_request_otp_data.dart';
import 'package:authentication_module/infrastructure/models/response/auth_request_otp_response_model.dart';

void main() {
  group('AuthRequestOtpResponseModel', () {
    final json = {
      'token': 'some-otp-token',
    };

    test('fromJson creates model', () {
      final model = AuthRequestOtpResponseModel.fromJson(json);
      expect(model.token, 'some-otp-token');
    });

    test('toJson produces correct map', () {
      final model = AuthRequestOtpResponseModel(token: 'some-otp-token');
      expect(model.toJson(), json);
    });

    test('toDomain returns AuthRequestOtpData', () {
      final model = AuthRequestOtpResponseModel.fromJson(json);
      final data = model.toDomain();
      expect(data, isA<AuthRequestOtpData>());
      expect(data.token, 'some-otp-token');
    });

    test('toString returns map representation', () {
      final model = AuthRequestOtpResponseModel(token: 't');
      expect(model.toString(), '{token: t}');
    });
  });
}
