import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {

  late final FirebaseAuth _firebaseAuth;

  AuthRepository() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  /// Stream do estado de autenticação
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Usuário atual
  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signIn({required String email, required String password}) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result;
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<User?> signUp(String email, String password) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> getValidIdToken({bool forceRefresh = false}) async {
    final user = _firebaseAuth.currentUser;
    return await user?.getIdToken(forceRefresh);
  }

}
