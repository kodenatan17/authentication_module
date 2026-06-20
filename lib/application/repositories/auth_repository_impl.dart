import 'package:hive/hive.dart';

import '../../domain/entities/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../infrastructure/datasource/auth_remote_datasource.dart';

/// Implementation of [AuthRepository] using remote data source + Hive token storage.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;

  static const _boxName = 'resident_auth';
  static const _tokenKey = 'access_token';

  AuthRepositoryImpl(this._remote);

  Box<dynamic>? _box;

  Future<Box<dynamic>> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<dynamic>(_boxName);
    }
    return _box!;
  }

  @override
  Future<AuthResult> login({
    required String phone,
    required String password,
  }) async {
    final response = await _remote.login(
      phone: phone,
      password: password,
    );
    final result = response.toEntity();
    if (result.success && result.token.isNotEmpty) {
      await _saveToken(result.token);
    }
    return result;
  }

  @override
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await _remote.verifyOtp(
      phone: phone,
      otp: otp,
    );
    final result = response.toEntity();
    if (result.success && result.token.isNotEmpty) {
      await _saveToken(result.token);
    }
    return result;
  }

  @override
  bool get isAuthenticated => token != null;

  @override
  String? get token {
    try {
      final box = Hive.isBoxOpen(_boxName) ? Hive.box<dynamic>(_boxName) : null;
      return box?.get(_tokenKey) as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    final box = await _getBox();
    await box.delete(_tokenKey);
  }

  Future<void> _saveToken(String token) async {
    final box = await _getBox();
    await box.put(_tokenKey, token);
  }
}
