import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_user.dart';

final class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthSession.fromLoginData(Map<String, dynamic> data) {
    final user = data['user'];
    final tokens = data['tokens'];
    if (user is! Map<String, dynamic> || tokens is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    return AuthSession._fromParts(user: user, tokens: tokens);
  }

  factory AuthSession.fromRefreshData(Map<String, dynamic> data) {
    final user = data['user'];
    if (user is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    return AuthSession._fromParts(user: user, tokens: data);
  }

  factory AuthSession._fromParts({
    required Map<String, dynamic> user,
    required Map<String, dynamic> tokens,
  }) {
    final accessToken = tokens['accessToken'];
    final refreshToken = tokens['refreshToken'];
    if (accessToken is! String ||
        accessToken.isEmpty ||
        refreshToken is! String ||
        refreshToken.isEmpty) {
      throw const InvalidResponseException();
    }

    try {
      return AuthSession(
        user: AuthUser.fromJson(user),
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } on FormatException {
      throw const InvalidResponseException();
    }
  }

  final AuthUser user;
  final String accessToken;
  final String refreshToken;
}
