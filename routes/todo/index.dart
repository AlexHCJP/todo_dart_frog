import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

import '../../core/database.dart';
import '../../data_source/todo_datasource.dart';
import '../../models/todo_model.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.delete:
      return _delete(context);
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(RequestContext context) async {
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final name = body['name'] as String?;

  if (name == null || name.isEmpty) {
    return Response(
      statusCode: HttpStatus.unprocessableEntity,
      body: jsonEncode({'error': 'Name is required'}),
    );
  }

  final todo = TodoModel.fromJson(body);

  await context.read<TodoDatasource>().addTodo(todo);

  return Response(body: jsonEncode({'message': 'OK'}));
}

Future<Response> _get(RequestContext context) async {
  final queryParameters = context.request.uri.queryParameters;
  final filter = queryParameters['filter'];

  final todos = await context.read<TodoDatasource>().getTodos();

  if (filter != null && filter.isNotEmpty) {
    final filteredTodos =
        todos.where((todo) => todo.name.toUpperCase().contains(filter.trim().toUpperCase())).toList();
    return Response(body: jsonEncode({'todos': filteredTodos}));
  }

  return Response(body: jsonEncode({'todos': todos}));
}

Future<Response> _delete(RequestContext context) async {
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
  final uuid = body['uuid'] as String?;

  if (uuid == null || uuid.isEmpty) {
    return Response(
      statusCode: HttpStatus.unprocessableEntity,
      body: jsonEncode({'error': 'uuid is required'}),
    );
  }

  await context.read<TodoDatasource>().removeTodo(uuid);

  return Response(body: jsonEncode({'message': 'OK'}));
}
