import 'package:postgres/postgres.dart';

import '../core/database.dart';
import '../models/todo_model.dart';

class TodoDatasource {
  Future<void> addTodo(TodoModel todo) async {
    await (await Database.instance).execute(
      Sql.named('INSERT INTO todo (name) VALUES (@name)'),
      parameters: {
        'name': todo.name,
      },
    );
  }

  Future<List<TodoModel>> getTodos() async {
    final result = await (await Database.instance).execute(
      Sql.named('SELECT * FROM todo'),
    );

    final cache = <TodoModel>[];
    for (final row in result) {
      cache.add(TodoModel.fromJson(row.toColumnMap()));
    }

    return List.unmodifiable(cache);
  }
  
  Future<void> updateTodo(TodoModel todo) async {
    await (await Database.instance).execute(
      Sql.named('UPDATE todo SET name = @name WHERE id = @id'),
      parameters: {
        'id': todo.id,
        'name': todo.name,
      },
    );
  }

  Future<void> removeTodo(String uuid) async {
    await (await Database.instance).execute(
      Sql.named('DELETE FROM todo WHERE id = @id'),
      parameters: {
        'id': uuid,
      },
    );
  }
}
