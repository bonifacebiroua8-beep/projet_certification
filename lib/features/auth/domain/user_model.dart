// lib/features/auth/domain/user_model.dart
class UserModel {
  final String id;
  final String email;
  UserModel({required this.id, required this.email});
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], email: json['email'] ?? '');
}