import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_module/domain/entities/auth_result.dart';
import 'package:authentication_module/infrastructure/models/auth_refresh_token_data_model.dart';
import 'package:authentication_module/infrastructure/models/user_model.dart';

void main() {
  group('AuthRefreshTokenDataModel', () {
    final json = {
      'success': true,
      'token': 'token-abc',
      'user': {
        'id': 1,
        'name': 'John',
        'phone': '08123',
        'avatar': '',
      },
    };

    test('fromJson creates model', () {
      final model = AuthRefreshTokenDataModel.fromJson(json);
      expect(model.success, true);
      expect(model.token, 'token-abc');
      expect(model.user.id, 1);
      expect(model.user.name, 'John');
    });

    test('fromJson handles empty json', () {
      final model = AuthRefreshTokenDataModel.fromJson({});
      expect(model.success, false);
      expect(model.token, '');
      expect(model.user.id, 0);
    });

    test('toJson produces correct map', () {
      final user = UserModel(id: 1, name: 'John', phone: '08123', avatar: '');
      final model = AuthRefreshTokenDataModel(
        success: true,
        token: 'token-abc',
        user: user,
      );
      expect(model.toJson(), {
        'success': true,
        'token': 'token-abc',
        'user': user.toJson(),
      });
    });

    test('toDomain returns AuthResult', () {
      final model = AuthRefreshTokenDataModel.fromJson(json);
      final result = model.toDomain();
      expect(result, isA<AuthResult>());
      expect(result.success, true);
      expect(result.token, 'token-abc');
      expect(result.user.id, 1);
    });

    test('props correct', () {
      final user = UserModel(id: 1, name: 'John', phone: '08123');
      final model = AuthRefreshTokenDataModel(
        success: true,
        token: 't',
        user: user,
      );
      expect(model.props, [true, 't', user]);
    });

    test('equality', () {
      final a = AuthRefreshTokenDataModel.fromJson(json);
      final b = AuthRefreshTokenDataModel.fromJson(json);
      expect(a, b);
    });
  });
}
