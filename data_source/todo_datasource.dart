import '../models/todo_model.dart';

class TodoDatasource {
  final _cache = <TodoModel>[];

  void addTodo(TodoModel todo) {
    _cache.add(todo);
  }

  List<TodoModel> getTodos() {
    return List.unmodifiable(_cache);
  }

  void removeTodo(String uuid) {
    _cache.removeWhere((todo) => todo.id == uuid);
  }
}