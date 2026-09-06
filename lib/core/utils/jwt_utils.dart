import 'dart:convert';

class JwtUtils {
  static String? extractUserId(String token) {
    try {
      final parts = token.split('.');
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final map = jsonDecode(payload);
      return map['sub'];
    } catch (_) {
      return null;
    }
  }
}