import 'package:equatable/equatable.dart';

/// Estados da autenticação
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuthInitial extends AuthState {}

/// Estado de carregamento
class AuthLoading extends AuthState {}

/// Estado autenticado
class AuthAuthenticated extends AuthState {
  final String userId;
  final String? userEmail;
  final String? userName;
  final String? userPhotoUrl;
  final Map<String, dynamic>? userData;

  const AuthAuthenticated({
    required this.userId,
    this.userEmail,
    this.userName,
    this.userPhotoUrl,
    this.userData,
  });

  @override
  List<Object?> get props => [userId, userEmail, userName, userPhotoUrl, userData];
}

/// Estado não autenticado
class AuthUnauthenticated extends AuthState {}

/// Estado de erro na autenticação
class AuthError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

/// Estado de logout em progresso
class AuthLogoutInProgress extends AuthState {}

/// Estado de reset de senha enviado
class AuthPasswordResetSent extends AuthState {}
