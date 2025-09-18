
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'enviroment.dart';

extension type JWTToken(String token) {
  JWTToken.create(Map<String, dynamic> payload)
      : this(JWT(payload).sign(SecretKey(Enviroment.secretKey)));

  JWTToken.fromBearer(String bearer) : this(bearer.replaceFirst('Bearer ', ''));

  bool validate() {
    try {
      final expiredAt = payload['expired_at'] as int;
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      return currentTime < expiredAt;
    } catch (e) {
      return false;
    }
  }

  Map<String, dynamic> get payload {
    try {
      final secretKey = SecretKey(Enviroment.secretKey);
      final jwt = JWT.verify(token, secretKey);
      return jwt.payload as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Invalid token');
    }
  }
}
