import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../data_source/auth_datasource.dart';

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
  final email = body['email'] as String?;
  final password = body['password'] as String?;

  if (email == null || email.isEmpty || password == null || password.isEmpty) {
    return Response(
      statusCode: HttpStatus.unprocessableEntity,
      body: jsonEncode({'error': 'Email and password are required'}),
    );
  }

  try {
    final userId = await context.read<AuthDatasource>().login(email, password);
    final tokens = await context.read<AuthDatasource>().getTokens(userId);

    return Response(
      body: jsonEncode({
        'access': tokens.accessToken,
        'refresh': tokens.refreshToken,
      }),
    );
  } catch (err) {
    return Response(
      statusCode: HttpStatus.unauthorized,
      body: jsonEncode({'error': 'Invalid email or password'}),
    );
  }
}
