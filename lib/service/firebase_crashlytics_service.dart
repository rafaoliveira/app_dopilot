import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseCrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  // Inicializar o Crashlytics
  Future<void> initialize() async {
    try {
      // Define se deve coletar crashes em modo debug
      await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

      // Captura erros do Flutter
      FlutterError.onError = _crashlytics.recordFlutterFatalError;

      // Captura erros assíncronos
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (e) {
      print('Erro ao inicializar Crashlytics: $e');
    }
  }

  // Registrar erro não fatal
  Future<void> recordError(dynamic exception, StackTrace? stackTrace, {bool fatal = false}) async {
    try {
      await _crashlytics.recordError(exception, stackTrace, fatal: fatal);
    } catch (e) {
      print('Erro ao registrar erro no Crashlytics: $e');
    }
  }

  // Registrar log personalizado
  Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);
    } catch (e) {
      print('Erro ao registrar log no Crashlytics: $e');
    }
  }

  // Definir ID do usuário
  Future<void> setUserId(String userId) async {
    try {
      await _crashlytics.setUserIdentifier(userId);
    } catch (e) {
      print('Erro ao definir ID do usuário no Crashlytics: $e');
    }
  }

  // Definir atributo personalizado
  Future<void> setCustomKey(String key, Object value) async {
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      print('Erro ao definir chave personalizada no Crashlytics: $e');
    }
  }

  // Simular crash para teste
  Future<void> testCrash() async {
    try {
      _crashlytics.crash();
    } catch (e) {
      print('Erro ao simular crash: $e');
    }
  }
}
