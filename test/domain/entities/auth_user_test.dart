import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_module/domain/entities/auth_user.dart';

void main() {
  group('AuthUser', () {
    const tUser = AuthUser(
      id: 1,
      name: 'John Doe',
      phone: '08123456789',
      avatar: 'avatar.jpg',
    );

    test('props correct', () {
      expect(tUser.props, [1, 'John Doe', '08123456789', 'avatar.jpg']);
    });

    test('empty avatar defaults to empty string', () {
      const user = AuthUser(id: 2, name: 'Jane', phone: '08123');
      expect(user.avatar, '');
    });

    test('copyWith changes fields', () {
      final copy = tUser.copyWith(name: 'Jane Doe', avatar: 'new.jpg');
      expect(copy.id, 1);
      expect(copy.name, 'Jane Doe');
      expect(copy.phone, '08123456789');
      expect(copy.avatar, 'new.jpg');
    });

    test('copyWith with null keeps fields', () {
      final copy = tUser.copyWith();
      expect(copy, tUser);
    });

    test('equality', () {
      const same = AuthUser(id: 1, name: 'John Doe', phone: '08123456789', avatar: 'avatar.jpg');
      expect(tUser, same);

      const different = AuthUser(id: 2, name: 'John', phone: '08123');
      expect(tUser, isNot(different));
    });
  });
}
