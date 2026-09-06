// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _build();
    return _dio!;
  }

  static Dio _build() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.restBaseUrl,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Content-Type': 'application/json',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SecureStorage.getAccessToken();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            final token = await SecureStorage.getAccessToken();
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            final clone = await Dio().fetch(error.requestOptions);
            return handler.resolve(clone);
          }
        }
        handler.next(error);
      },
    ));

    return dio;
  }

  static Future<bool> _refreshToken() async {
    final refresh = await SecureStorage.getRefreshToken();
    if (refresh == null) return false;
    try {
      final res = await Dio().post(
        '${AppConfig.authBaseUrl}/token?grant_type=refresh_token',
        options: Options(headers: {'apikey': AppConfig.supabaseAnonKey}),
        data: {'refresh_token': refresh},
      );
      await SecureStorage.saveTokens(res.data['access_token'], res.data['refresh_token']);
      return true;
    } catch (_) {
      await SecureStorage.clear();
      return false;
    }
  }
}