import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_module/domain/entities/auth_result.dart';
import 'package:authentication_module/domain/entities/auth_user.dart';

void main() {
  group('AuthResult', () {
    const tUser = AuthUser(id: 1, name: 'John', phone: '08123');
    const tResult = AuthResult(success: true, token: 'abc123', user: tUser);

    test('props correct', () {
      expect(tResult.props, [true, 'abc123', tUser]);
    });

    test('copyWith changes fields', () {
      final copy = tResult.copyWith(success: false, token: 'xyz');
      expect(copy.success, false);
      expect(copy.token, 'xyz');
      expect(copy.user, tUser);
    });

    test('copyWith with null keeps fields', () {
      final copy = tResult.copyWith();
      expect(copy, tResult);
    });

    test('equality', () {
      const same = AuthResult(success: true, token: 'abc123', user: tUser);
      expect(tResult, same);

      const different = AuthResult(success: false, token: 'def', user: tUser);
      expect(tResult, isNot(different));
    });
  });
}
