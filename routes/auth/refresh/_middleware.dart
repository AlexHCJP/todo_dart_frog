import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../core/jwt.dart';
import '../../../data_source/auth_datasource.dart';
import '../../../models/user_model.dart';

Handler middleware(Handler handler) {
  return (context) async {
    
    final response = await handler(context);

    final authHeader = response.headers[HttpHeaders.authorizationHeader];

    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response(
        statusCode: HttpStatus.unauthorized,
        body: 'Missing or invalid Authorization header',
      );
    }

    final token = JWTToken.fromBearer(authHeader);

    final authDatasource = context.read<AuthDatasource>();

    final user =
        await authDatasource.getUserById(token.payload['id'] as String);

    context.provide<UserModel>(() => user);

    return response;
  };
}
