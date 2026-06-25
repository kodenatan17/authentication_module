import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_module/domain/entities/auth_user.dart';
import 'package:authentication_module/infrastructure/models/user_model.dart';

void main() {
  group('UserModel', () {
    final json = {
      'id': 1,
      'name': 'John Doe',
      'phone': '08123456789',
      'avatar': 'avatar.jpg',
    };

    test('fromJson creates model', () {
      final model = UserModel.fromJson(json);
      expect(model.id, 1);
      expect(model.name, 'John Doe');
      expect(model.phone, '08123456789');
      expect(model.avatar, 'avatar.jpg');
    });

    test('fromJson handles empty json', () {
      final model = UserModel.fromJson({});
      expect(model.id, 0);
      expect(model.name, '');
      expect(model.phone, '');
      expect(model.avatar, '');
    });

    test('fromJson handles null values', () {
      final model = UserModel.fromJson({
        'id': null,
        'name': null,
        'phone': null,
        'avatar': null,
      });
      expect(model.id, 0);
      expect(model.name, '');
      expect(model.phone, '');
      expect(model.avatar, '');
    });

    test('toJson produces correct map', () {
      final model = UserModel(id: 1, name: 'John', phone: '08123', avatar: 'a.jpg');
      expect(model.toJson(), {
        'id': 1,
        'name': 'John',
        'phone': '08123',
        'avatar': 'a.jpg',
      });
    });

    test('toDomain returns AuthUser', () {
      final model = UserModel(id: 1, name: 'John', phone: '08123', avatar: 'a.jpg');
      final user = model.toDomain();
      expect(user, isA<AuthUser>());
      expect(user.id, 1);
      expect(user.name, 'John');
      expect(user.phone, '08123');
      expect(user.avatar, 'a.jpg');
    });

    test('props correct', () {
      final model = UserModel(id: 1, name: 'John', phone: '08123', avatar: 'a.jpg');
      expect(model.props, [1, 'John', '08123', 'a.jpg']);
    });

    test('equality', () {
      final a = UserModel(id: 1, name: 'John', phone: '08123');
      final b = UserModel(id: 1, name: 'John', phone: '08123');
      final c = UserModel(id: 2, name: 'Jane', phone: '08999');
      expect(a, b);
      expect(a, isNot(c));
    });
  });
}
