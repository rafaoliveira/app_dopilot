import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: _analytics);

  // Log de eventos personalizados
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      print('Erro ao registrar evento: $e');
    }
  }

  // Log de login
  Future<void> logLogin(String method) async {
    await logEvent('login', parameters: {'login_method': method});
  }

  // Log de criação de tarefa
  Future<void> logTaskCreated() async {
    await logEvent('task_created');
  }

  // Log de conclusão de tarefa
  Future<void> logTaskCompleted() async {
    await logEvent('task_completed');
  }

  // Definir propriedade do usuário
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      print('Erro ao definir propriedade do usuário: $e');
    }
  }

  // Definir ID do usuário
  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      print('Erro ao definir ID do usuário: $e');
    }
  }
}
