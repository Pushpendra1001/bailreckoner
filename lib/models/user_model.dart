class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'phoneNumber': phoneNumber,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    role: json['role'] as String,
    phoneNumber: json['phoneNumber'] as String?,
  );
}
