class TodoModel {
  TodoModel._({required String? id, required this.name}) : _id = id;

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel._(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  factory TodoModel.create(Map<String, dynamic> json) {
    return TodoModel._(
      id: null,
      name: json['name'] as String,
    );
  }

  final String? _id;
  final String name;

  String? get id => _id;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': name,
    };
  }
}
