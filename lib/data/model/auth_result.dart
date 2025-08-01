import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final User? user;

  AuthResult._({
    required this.isSuccess,
    this.errorMessage,
    this.user,
  });

  factory AuthResult.success({User? user}) {
    return AuthResult._(
      isSuccess: true,
      user: user,
    );
  }

  factory AuthResult.error(String message) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
}