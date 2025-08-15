import 'dart:io';

import 'package:app_dopilot/repository/device_token_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/dto/device_token_request_dto.dart';
import 'auth_service.dart';

/// Serviço Firebase para configuração e gerenciamento de notificações
class FirebaseService {
  static FirebaseMessaging? _messaging;

  // Chaves para SharedPreferences
  static const String _fcmTokenKey = 'fcm_token';
  static const String _tokenSentKey = 'fcm_token_sent';

  final AuthService _authService = AuthService();
  final DeviceTokenRepository _deviceTokenRepository = DeviceTokenRepository();
  late final prefs;

  /// Inicializar Firebase Messaging
  Future<void> initialize() async {
    try {

      prefs = await SharedPreferences.getInstance();

      _messaging = FirebaseMessaging.instance;

      // Solicitar permissões
      await _requestPermissions();

      // Configurar handlers de mensagens
      _setupMessageHandlers();

      // Para iOS, aguardar APNS token estar disponível antes de tentar obter FCM token
      if (Platform.isIOS) {
        await _waitForAPNSToken();
      }

      // Obter e registrar token FCM inicial
      await _handleTokenRefresh();

      // Escutar mudanças de token
      _messaging!.onTokenRefresh.listen(_onTokenRefresh);

    } catch (e) {
      print('FirebaseService: Erro na inicialização - $e');
    }
  }

  /// Solicitar permissões para notificações
  Future<void> _requestPermissions() async {
    try {
       await _messaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

    } catch (e) {
      print('FirebaseService: Erro - ${e.toString()}');
    }
  }

  /// Configurar handlers de mensagens
  void _setupMessageHandlers() {
    try {
      // Mensagem recebida quando app está em foreground
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Registrar handler para mensagens em background
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Mensagem que abriu o app (background/terminated)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Verificar se app foi aberto por notificação
      _checkInitialMessage();

    } catch (e) {
      print('FirebaseService Erro Message handlers: ${e.toString()}');
    }
  }

  /// Lidar com token refresh e enviar para API
  Future<void> _handleTokenRefresh() async {
    try {
      // No iOS, tentar aguardar APNS token mas não bloquear indefinidamente
      if (Platform.isIOS) {
        await _waitForAPNSToken();

        // Verificar novamente se APNS token está disponível
        final apnsToken = await _messaging!.getAPNSToken();

        if (apnsToken == null) {
          print('FirebaseService: APNS token ainda null, mas continuando (simulador?)');
          // No simulador, FCM pode funcionar mesmo sem APNS token
        } else {
          print('FirebaseService: APNS token disponível: ${apnsToken.substring(0, 10)}...');
        }
      }

      // Tentar obter FCM token mesmo se APNS for null (para simulador)
      final token = await _messaging!.getToken();
      if (token != null) {
        print('FirebaseService: FCM token obtido: ${token.substring(0, 20)}...');
        await _onTokenRefresh(token);
      } else {
        print('FirebaseService: FCM token também é null');
      }
    } catch (e) {
      print('FirebaseService: Erro ao obter token FCM - ${e.toString()}');
    }
  }

  /// Callback para quando token FCM é atualizado
  Future<void> _onTokenRefresh(String token) async {
    try {

      // Salvar token localmente
      await prefs.setString(_fcmTokenKey, token);

      // Verificar se já foi enviado para API
      final lastSentToken = prefs.getString('${_tokenSentKey}_last') ?? '';

      if (lastSentToken != token) {
        // Enviar para API DOPilot
        final success = await sendTokenToAPI();

        if (success) {
          // Marcar como enviado
          await prefs.setString('${_tokenSentKey}_last', token);
          await prefs.setBool(_tokenSentKey, true);
        } else {
          await prefs.setBool(_tokenSentKey, false);
        }
      }
    } catch (e) {
      print('FirebaseService: Erro ao processar token refresh - ${e.toString()}');
    }
  }

  /// Enviar token FCM para API DOPilot
  Future<bool> sendTokenToAPI() async {
    try {
      // Verificar se há usuário autenticado
      if (!_authService.isLoggedIn) {
        return false;
      }

      final request = DeviceTokenRequestDto(
        token: prefs.getString(_fcmTokenKey),
        deviceId: await _getDeviceId(),
        platform: Platform.isIOS ? 'ios' : 'android',
        deviceModel: await _getDeviceModel(),
      );

      final response = await _deviceTokenRepository.registerDeviceToken(request);

      if (response != null) {
        return true;
      }

      return false;
    } catch (e) {
      print('FirebaseService: Exceção ao enviar token FCM: $e');
      return false;
    }
  }

  /// Handler para mensagem em foreground
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      print('FirebaseService: Mensagem recebida em foreground: ${message.notification?.title} - ${message.notification?.body}');
      print(message);
    } catch (e) {}
  }

  /// Handler para quando app é aberto por notificação
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    try {
      // TODO: Navegar para tela específica baseada nos dados da notificação
      print('FirebaseService: App aberto por notificação: ${message.notification?.title} - ${message.notification?.body}');
    } catch (e) {}
  }

  /// Verificar mensagem inicial (app aberto por notificação)
  Future<void> _checkInitialMessage() async {
    try {
      RemoteMessage? initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();

      if (initialMessage != null) {
        // TODO: Processar mensagem inicial
      }
    } catch (e) {
      print('FirebaseService: Erro ao verificar mensagem inicial - $e');
    }
  }


  /// Obter ID único do dispositivo
  Future<String> _getDeviceId() async {
    try {
      // TODO: Implementar com device_info_plus se necessário
      return Platform.isIOS ? 'ios_device_id' : 'android_device_id';
    } catch (e) {
      print('FirebaseService: Erro ao obter device ID - $e');
      return 'unknown_device_id';
    }
  }

  /// Obter modelo do dispositivo
  Future<String> _getDeviceModel() async {
    try {
      // TODO: Implementar com device_info_plus se necessário
      return Platform.isIOS ? 'iPhone' : 'Android';
    } catch (e) {
      print('FirebaseService: Erro ao obter device model - $e');
      return 'Unknown';
    }
  }

  /// Aguardar APNS token estar disponível (iOS)
  Future<void> _waitForAPNSToken() async {
    try {
      int attempts = 0;
      int maxAttempts = 1; // Aumentar tentativas
      Duration delayBetweenAttempts = const Duration(milliseconds: 1000); // Aumentar delay

      while (attempts < maxAttempts) {
        final apnsToken = await _messaging!.getAPNSToken();

        if (apnsToken != null) {
          print('FirebaseService: APNS token obtido com sucesso após $attempts tentativas');
          return;
        }

        attempts++;
        print('FirebaseService: Tentativa $attempts/$maxAttempts - APNS token ainda null');

        if (attempts < maxAttempts) {
          await Future.delayed(delayBetweenAttempts);
        }
      }

      print('FirebaseService: APNS token permanece null após $maxAttempts tentativas');

      // Se está no simulador, continuar mesmo sem APNS token
      if (Platform.isIOS) {
        print('FirebaseService: Prosseguindo sem APNS token (pode ser simulador)');
      }

    } catch (e) {
      print('FirebaseService: Erro ao aguardar APNS token: $e');
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    print('FirebaseService: Mensagem em background recebida: ${message.notification?.title}');

    // Aqui você pode processar a notificação em background
    // Evite operações complexas pois o sistema pode matar o processo

  } catch (e) {
    print('FirebaseService: Erro no background handler - $e');
  }
}
