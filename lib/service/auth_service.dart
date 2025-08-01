import 'package:app_dopilot/data/model/auth_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repository.dart';

class AuthService {

  late final AuthRepository _authRepository;
  late final SharedPreferences _preferences;

  // Chaves para SharedPreferences
  static const String _accessTokenKey = 'dopilot_access_token';
  static const String _refreshTokenKey = 'dopilot_refresh_token';
  static const String _tokenExpiryKey = 'dopilot_token_expiry';
  static const String _userIdKey = 'dopilot_user_id';

  AuthService() {
    _authRepository = AuthRepository();
    _initPreferences();
  }

  /// Stream do estado de autenticação
  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  /// Usuário atual
  User? get currentUser => _authRepository.currentUser;

  /// Inicializar SharedPreferences
  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Login com email e senha
  Future<AuthResult> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {

    try {
      final UserCredential credential = await _authRepository.signIn(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        final user = credential.user!;

        // Obter token do Firebase para usar como access token
        final idToken = await user.getIdToken();
        final refreshToken = user.refreshToken;

        // Salvar tokens no TokenService
        if (refreshToken != null && idToken != null && idToken.isNotEmpty) {
          final tokenSaved = await saveTokens(
            accessToken: idToken,
            refreshToken: refreshToken,
            expiresInSeconds: 3600, // 1 hora (padrão Firebase)
            userId: user.uid,
          );

          if (!tokenSaved) {
            print('⚠️ Aviso: Falha ao salvar tokens, mas login foi bem-sucedido');
          }
        }

        return AuthResult.success(user: user);
      } else {
        return AuthResult.error('Erro desconhecido no login');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('Erro inesperado: ${e.toString()}');
    }
  }

  /// Login com Google
  Future<AuthResult> loginInWithGoogle() async {
    try {
      // Configurar Google Sign In com clientId específico do iOS
      final GoogleSignIn googleSignIn = GoogleSignIn(
        // O clientId é opcional se estiver configurado corretamente no firebase_options.dart
        // Mas pode ser necessário para iOS em alguns casos
        // clientId: '68692557861-cmgf654l5o6t7tv57g894ifesiou7f3p.apps.googleusercontent.com',
      );

      // Verificar se há um usuário já logado e fazer logout primeiro
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Se o usuário cancelou o login
      if (googleUser == null) {
        return AuthResult.error('Login cancelado pelo usuário');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Verificar se os tokens foram obtidos
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        return AuthResult.error('Falha ao obter tokens do Google');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _authRepository.signInWithCredential(credential);

      if (userCredential.user != null) {
        final user = userCredential.user!;

        // Verificar se é o primeiro login (criar documento no Firestore)
        //final userDoc = await _firestore.collection('users').doc(user.uid).get();
        //if (!userDoc.exists) {
        //  await _createUserDocument(user, user.displayName ?? 'Usuário Google');
        //}

        // Obter token do Firebase para usar como access token
        final idToken = await user.getIdToken();
        final refreshToken = user.refreshToken;

        // Salvar tokens no TokenService
        if (refreshToken != null && idToken != null && idToken.isNotEmpty) {
          final tokenSaved = await saveTokens(
            accessToken: idToken,
            refreshToken: refreshToken,
            expiresInSeconds: 3600, // 1 hora (padrão Firebase)
            userId: user.uid,
          );

          if (!tokenSaved) {
            print('⚠️ Aviso: Falha ao salvar tokens após login com Google');
          }
        }

        return AuthResult.success(user: user);
      }

      return AuthResult.error('Falha ao autenticar com Google');

    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e.code));
    } catch (e) {

      return AuthResult.error('Erro inesperado: ${e.toString()}');
    }
  }

  Future<bool> register(String email, String password) async {
    final user = await _authRepository.signUp(email, password);
    return user != null;
  }

  Future<void> logout() async {
    await _authRepository.signOut();
  }

  bool get isLoggedIn => _authRepository.currentUser != null;

  Future<String?> getValidToken() async {
    try {
      return await _authRepository.getValidIdToken(forceRefresh: true);
    } catch (e) {
      print('Erro ao renovar token: $e');
      return null;
    }
  }

  static String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Usuário não encontrado';
      case 'wrong-password':
        return 'Senha incorreta';
      case 'email-already-in-use':
        return 'Este email já está em uso';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Esta conta foi desabilitada';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde';
      case 'operation-not-allowed':
        return 'Operação não permitida';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet';
      default:
        return 'Erro desconhecido: $errorCode';
    }
  }

  /// Salvar tokens após login bem-sucedido
  Future<bool> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
    required String userId,
  }) async {
    try {

      // Calcular timestamp de expiração
      final expiryTimestamp = DateTime.now()
          .add(Duration(seconds: expiresInSeconds))
          .millisecondsSinceEpoch;

      // Salvar todos os dados de autenticação
      final results = await Future.wait([
        _preferences.setString(_accessTokenKey, accessToken),
        _preferences.setString(_refreshTokenKey, refreshToken),
        _preferences.setInt(_tokenExpiryKey, expiryTimestamp),
        _preferences.setString(_userIdKey, userId),
      ]);

      final allSaved = results.every((result) => result);

      if (allSaved) {
        print('✅ Tokens salvos com sucesso para usuário: $userId');
        return true;
      } else {
        throw Exception('Falha ao salvar um ou mais tokens');
      }
    } catch (e) {
      print('❌ Erro ao salvar tokens: $e');
      return false;
    }
  }

}
