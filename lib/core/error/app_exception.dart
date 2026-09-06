import 'package:dio/dio.dart';

enum ErrorType { network, timeout, server, unknown }

class AppException implements Exception {
  final String message;
  final ErrorType type;
  AppException(this.message, this.type);
}

AppException mapDioException(Object e) {
  if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException('Délai dépassé. Vérifie ta connexion.', ErrorType.timeout);
      case DioExceptionType.connectionError:
        return AppException('Pas de connexion réseau.', ErrorType.network);
      case DioExceptionType.badResponse:
        return AppException('Erreur serveur (${e.response?.statusCode ?? ''}).', ErrorType.server);
      default:
        return AppException('Erreur inattendue.', ErrorType.unknown);
    }
  }
  return AppException('Erreur inattendue.', ErrorType.unknown);
}