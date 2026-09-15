import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';

part 'auth_session.freezed.dart';

@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required AuthAccount account,
    required String accessToken,
    required String refreshToken,
  }) = _AuthSession;

  static AuthSession fromLoginData(Map<String, dynamic> data) {
    final account = data['account'];
    final tokens = data['tokens'];
    if (account is! Map<String, dynamic> || tokens is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    return AuthSession._fromParts(account: account, tokens: tokens);
  }

  static AuthSession fromRefreshData(Map<String, dynamic> data) {
    final account = data['account'];
    if (account is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    return AuthSession._fromParts(account: account, tokens: data);
  }

  static AuthSession _fromParts({
    required Map<String, dynamic> account,
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

    return AuthSession(
      account: AuthAccount.parse(account),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
