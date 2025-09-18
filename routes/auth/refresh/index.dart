import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../core/jwt.dart';
import '../../../data_source/auth_datasource.dart';
import '../../../models/user_model.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.get:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(RequestContext context) async {
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final refresh = JWTToken(body['refresh'] as String? ?? '');

  if (refresh == null || refresh.token.isEmpty) {
    return Response(
      statusCode: HttpStatus.unprocessableEntity,
      body: jsonEncode({'error': 'Refresh token is required'}),
    );
  }

  final user = context.read<UserModel>();

  if (user.id != refresh.payload['id']) {
    return Response(
      statusCode: HttpStatus.unauthorized,
      body: jsonEncode({'error': 'Invalid refresh token'}),
    );
  }

  try {
    final tokens = await context.read<AuthDatasource>().refreshTokens(refresh);

    return Response(
      body: jsonEncode({
        'access': tokens.accessToken,
        'refresh': tokens.refreshToken,
      }),
    );
  } catch (err) {
    return Response(
      statusCode: HttpStatus.unauthorized,
      body: jsonEncode({'error': 'Invalid refresh token'}),
    );
  }
}
