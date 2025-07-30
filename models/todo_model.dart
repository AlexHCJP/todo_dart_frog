import 'package:uuid/uuid.dart';

class TodoModel {

  TodoModel({
    required this.id,
    required this.name,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: const Uuid().v4(),
      name: json['name'] as String,
    );
  }
  
  final String id;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'uuid': id,
      'name': name,
    };
  }
}
