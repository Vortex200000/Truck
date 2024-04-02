import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends Equatable {
  @HiveField(0)
  final String email;
  @HiveField(1)
  final String password;

//<editor-fold desc="Data Methods">
  const User({
    required this.email,
    required this.password,
  });

  @override
  String toString() {
    return 'User{ email: $email, password: $password,}';
  }

  User copyWith({
    String? id,
    String? email,
    String? password,
  }) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  @override
  List<Object?> get props => [email];

//</editor-fold>
}
