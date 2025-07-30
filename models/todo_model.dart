class TodoModel {
  TodoModel({
    required String id,
    required this.name,
  }) : _id = id;

  TodoModel._(this._id, this.name);

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  factory TodoModel.create(Map<String, dynamic> json) {
    return TodoModel._(
      null,
      json['name'] as String,
    );
  }

  final String? _id;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
      'name': name,
    };
  }
}
