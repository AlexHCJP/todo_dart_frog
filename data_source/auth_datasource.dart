import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:postgres/postgres.dart';

import '../core/database.dart';

class AuthDatasource {
  Future<String> login(String email, String password) async {
    final result = await (await Database.instance).execute(
      Sql.named(
          'SELECT * FROM users WHERE email = @email AND password = @password'),
      parameters: {
        'email': email,
        'password': password,
      },
    );

    if (result.isEmpty) {
      throw Exception('Invalid email or password');
    }
    return result.first.toColumnMap()['id'] as String;
  }

  Future<GetTokensResult> getTokens(String id) async {
    final jwtAccess = JWT(
      {
        'id': id,
        'expired_at': DateTime.now()
            .add(const Duration(minutes: 1))
            .millisecondsSinceEpoch,
      },
      issuer: 'access',
    );

    final jwtRefresh = JWT(
      {
        'id': id,
        'expired_at':
            DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      },
      issuer: 'refresh',
    );

    final secretKey = SecretKey('your_super_secret_key');
    final accessToken = jwtAccess.sign(secretKey);
    final refreshToken = jwtRefresh.sign(secretKey);

    await (await Database.instance).execute(
      Sql.named('INSERT INTO access_tokens (token) VALUES (@token)'),
      parameters: {
        'token': accessToken,
      },
    );

    await (await Database.instance).execute(
      Sql.named('INSERT INTO refresh_tokens (token) VALUES (@token)'),
      parameters: {
        'token': 'some_refresh_token_value',
      },
    );

    return GetTokensResult(accessToken, refreshToken);
  }
}

class GetTokensResult {
  const GetTokensResult(this.accessToken, this.refreshToken);

  final String accessToken;
  final String refreshToken;
}
