import 'package:app_dopilot/service/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../service/auth_service.dart';
import 'auth_state.dart';

/// Cubit para gerenciamento de autenticação com BLoC
/// 
/// Centraliza o controle de login, logout e estado do usuário
/// Integrado com Firebase Auth, TokenService e FirebaseService
class AuthCubit extends Cubit<AuthState> {

  late final AuthService _authService;
  late final FirebaseService _firebaseService;

  AuthCubit() : super(AuthInitial()) {
    _authService = AuthService();
    _firebaseService = FirebaseService();
    _initAuthListener();
  }

  /// Inicializar listener de mudanças de autenticação
  void _initAuthListener() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        // Carregar dados do usuário quando logado
        //final userData = await _loadUserData(user);
        emit(AuthAuthenticated(
          userId: user.uid,
          userEmail: user.email,
          userName: userData?['name'] ?? user.displayName,
          userPhotoUrl: userData?['photoUrl'] ?? user.photoURL,
          userData: userData,
        ));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }


  /// Login com email e senha
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      final result = await _authService.loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.isSuccess) {
        // Sincronizar token FCM após login bem-sucedido
        await _firebaseService.sendTokenToAPI();

        // O listener já vai emitir AuthAuthenticated
      } else {
        emit(AuthError(message: result.errorMessage ?? 'Erro no login'));
      }
    } catch (e) {
      emit(AuthError(message: 'Erro inesperado no login: $e'));
    }
  }

  /// Login com Google
  Future<void> loginWithGoogle() async {
    try {
      emit(AuthLoading());

      final result = await _authService.loginInWithGoogle();

      if (result.isSuccess) {
        // Sincronizar token FCM após login bem-sucedido
        //await FirebaseService.syncTokenWithAPI();

        // O listener já vai emitir AuthAuthenticated
      } else {
        emit(AuthError(message: result.errorMessage ?? 'Erro no login com Google'));
      }
    } catch (e) {
      emit(AuthError(message: 'Erro inesperado no login com Google: $e'));
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      emit(AuthLoading());

      // Limpar token FCM antes do logout
      //await FirebaseService.clearToken();

      await _authService.logout();

      // O listener já vai emitir AuthUnauthenticated
    } catch (e) {
      emit(AuthError(message: 'Erro no logout: $e'));
    }
  }

  /// Limpar erro
  void clearError() {
    if (state is AuthError) {
      emit(AuthUnauthenticated());
    }
  }

  /// Getter para verificar se está logado
  bool get isLoggedIn => state is AuthAuthenticated;

  /// Getter para verificar se está carregando
  bool get isLoading => state is AuthLoading;

  /// Getter para obter dados do usuário
  Map<String, dynamic>? get userData {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      return currentState.userData;
    }
    return null;
  }

  /// Getter para obter User do Firebase
  User? get user => _authService.currentUser;
}