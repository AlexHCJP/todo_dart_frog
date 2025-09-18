import 'package:postgres/postgres.dart';
import '../core/database.dart';
import '../core/jwt.dart';
import '../models/user_model.dart';

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

  Future<UserModel> getUserById(String id) async {
    final result = await (await Database.instance).execute(
      Sql.named('SELECT * FROM users WHERE id = @id'),
      parameters: {
        'id': id,
      },
    );

    if (result.isEmpty) {
      throw Exception('User not found');
    }

    return UserModel.fromMap(result.first.toColumnMap());
  }

  Future<GetTokensResult> getTokens(String id) async {
    final accessToken = JWTToken.create(
      {
        'id': id,
        'expired_at': DateTime.now()
            .add(const Duration(minutes: 1))
            .millisecondsSinceEpoch,
      },
    );

    final refreshToken = JWTToken.create(
      {
        'id': id,
        'expired_at':
            DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      },
    );

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

  Future<GetTokensResult> refreshTokens(JWTToken refreshToken) async {
    try {
      if (refreshToken.validate() == false) {
        throw Exception('Invalid refresh token');
      }
      final userId = refreshToken.payload['id'] as String;
      final newTokens = await getTokens(userId);
      return newTokens;
    } catch (e) {
      throw Exception('Invalid refresh token');
    }
  }
}

class GetTokensResult {
  const GetTokensResult(this.accessToken, this.refreshToken);

  final JWTToken accessToken;
  final JWTToken refreshToken;
}
