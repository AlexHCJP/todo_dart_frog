import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final name = body['name'] as String?;

  if (name == null || name.isEmpty) {
    return Response(
      statusCode: 422,
      body: jsonEncode(
        {
          'error': 'Name is required',
        },
      ),
    );
  }
  if(name.length <= 4) {
    return Response(
      statusCode: 422,
      body: jsonEncode(
        {
          'error': 'Name must be longer than 4 characters',
        },
      ),
    );
  }

  return Response(body: jsonEncode({'message': 'Hello, $name'}));
}
