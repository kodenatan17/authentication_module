import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import 'package:core_module/core_module.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

abstract class AuthLocalDataSource {
  Future<void> setToken(String accessToken, String refreshToken);

  Future<void> removeToken();

  Future<String> getAccessToken();

  Future<String> getRefreshToken();

  Future<bool> isUserLoggedIn();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> setToken(
    String accessToken,
    String refreshToken,
  ) async {
    try {
      // final jwtDecode = JwtDecoder.decode(accessToken);
      final key = await SecureHive().getKey();
      final authBox = await Hive.openBox(
        CoreHiveBoxName.authBox,
        encryptionCipher: HiveAesCipher(key),
      );
      authBox.put(CoreHiveBoxName.accessTokenKey, accessToken);
      authBox.put(CoreHiveBoxName.refreshTokenKey, refreshToken);
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<String> getAccessToken() async {
    try {
      final key = await SecureHive().getKey();
      final authBox = await Hive.openBox(
        CoreHiveBoxName.authBox,
        encryptionCipher: HiveAesCipher(key),
      );
      return authBox.get(CoreHiveBoxName.accessTokenKey) ?? "";
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<String> getRefreshToken() async {
    try {
      final key = await SecureHive().getKey();
      final authBox = await Hive.openBox(
        CoreHiveBoxName.authBox,
        encryptionCipher: HiveAesCipher(key),
      );
      return authBox.get(CoreHiveBoxName.refreshTokenKey) ?? "";
    } catch (e) {
      throw const CacheException();
    }
  }
  
  @override
  Future<bool> isUserLoggedIn() async {
    final key = await SecureHive().getKey();
    final authBox = await Hive.openBox(
      CoreHiveBoxName.authBox,
      encryptionCipher: HiveAesCipher(key),
    );

    final String? accessToken = authBox.get(CoreHiveBoxName.accessTokenKey);
    if (accessToken != null) {
      if (!isTokenExpired(accessToken)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  @override
  Future<void> removeToken() async {
    try {
      final key = await SecureHive().getKey();
      final authBox = await Hive.openBox(
        CoreHiveBoxName.authBox,
        encryptionCipher: HiveAesCipher(key),
      );
      authBox.delete(CoreHiveBoxName.accessTokenKey);
      authBox.delete(CoreHiveBoxName.refreshTokenKey);
      authBox.delete(CoreHiveBoxName.agoraIdKey);
    } catch (e) {
      throw const CacheException();
    }
  }
}