class UserModel {

  UserModel({
    required this.id,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      email: map['email'] as String,
    );
  }

  final int id;
  final String email;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
    };
  }
}