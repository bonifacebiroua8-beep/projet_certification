import '../../../core/storage/secure_storage.dart';
import '../../../core/utils/jwt_utils.dart';
import 'auth_remote_datasource.dart';

class AuthRepository {
  final _remote = AuthRemoteDataSource();

  Future<bool> login(String email, String password) async {
    try {
      final data = await _remote.login(email, password);
      await SecureStorage.saveTokens(data['access_token'], data['refresh_token']);
      final uid = JwtUtils.extractUserId(data['access_token']);
      if (uid != null) await SecureStorage.saveUserId(uid);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      await _remote.register(email, password);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() => SecureStorage.clear();
}