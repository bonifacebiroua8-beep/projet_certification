// lib/features/auth/data/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';

class AuthRemoteDataSource {
  final _dio = Dio(BaseOptions(
    baseUrl: AppConfig.authBaseUrl,
    headers: {'apikey': AppConfig.supabaseAnonKey, 'Content-Type': 'application/json'},
  ));

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio.post('/token?grant_type=password',
        data: {'email': email, 'password': password});
    return res.data;
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final res = await _dio.post('/signup', data: {'email': email, 'password': password});
    return res.data;
  }
}