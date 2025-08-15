import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Inicializar o Remote Config
  Future<void> initialize() async {
    try {
      // Configurar settings
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: Duration.zero,
      ));

      // Definir valores padrão
      await _remoteConfig.setDefaults({
        'welcome_message': 'Bem-vindo ao DoPilot!',
        'max_tasks_per_user': 100,
        'enable_notifications': true,
        'app_version_required': '1.0.0',
        'maintenance_mode': false,
        'api_base_url': 'https://ms-dopilot-v1.onrender.com/dopilot',
        'connect_timeout_ms': 15000,
        'receive_timeout_ms': 15000,
      });

      // Fazer fetch inicial
      await fetchAndActivate();

      print('Remote Config inicializado com sucesso.');
      print(_remoteConfig.getString('api_base_url'));

      // Configurar settings
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));


    } catch (e) {
      print('Erro ao inicializar Remote Config: $e');
    }
  }

  // Buscar e ativar configurações
  Future<bool> fetchAndActivate() async {
    try {
      return await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Erro ao buscar configurações remotas: $e');
      return false;
    }
  }


  // Obter string
  String getString(String key) {
    try {
      return _remoteConfig.getString(key);
    } catch (e) {
      print('Erro ao obter string $key: $e');
      return '';
    }
  }

  // Obter boolean
  bool getBool(String key) {
    try {
      return _remoteConfig.getBool(key);
    } catch (e) {
      print('Erro ao obter boolean $key: $e');
      return false;
    }
  }

  // Obter int
  int getInt(String key) {
    try {
      return _remoteConfig.getInt(key);
    } catch (e) {
      print('Erro ao obter int $key: $e');
      return 0;
    }
  }

  // Obter double
  double getDouble(String key) {
    try {
      return _remoteConfig.getDouble(key);
    } catch (e) {
      print('Erro ao obter double $key: $e');
      return 0.0;
    }
  }

  // Métodos específicos para a aplicação
  String getWelcomeMessage() => getString('welcome_message');
  int getMaxTasksPerUser() => getInt('max_tasks_per_user');
  bool isNotificationsEnabled() => getBool('enable_notifications');
  String getRequiredAppVersion() => getString('app_version_required');
  bool isMaintenanceMode() => getBool('maintenance_mode');
  String getApiBaseUrl() => getString('api_base_url');
  int getConnectTimeoutMs() => getInt('connect_timeout_ms');
  int getReceiveTimeoutMs() => getInt('receive_timeout_ms');
}
