import '../util/dio_client.dart';
import '../data/dto/device_token_request_dto.dart';
import '../data/dto/device_token_response_dto.dart';
import '../data/dto/token_unregister_request_dto.dart';

/// Serviço para integração com a API de Device Tokens do DOPilot
/// 
/// Responsável por gerenciar tokens de dispositivos para notificações push
/// 
/// Endpoints da API:
/// - POST /api/v1/device-tokens - Registrar token de dispositivo
/// - DELETE /api/v1/device-tokens - Remover registro de token
class DeviceTokenRepository {
  
  /// Registrar token de dispositivo para notificações push
  static Future<DeviceTokenResponseDto?> registerDeviceToken(
    DeviceTokenRequestDto request,
  ) async {
    try {
      final response = await DioClient.post(
        '/api/v1/device-tokens',
        data: request.toJson(),
      );

      if (response.isSuccess && response.data != null) {
        final deviceToken = DeviceTokenResponseDto.fromJson(response.data);
        return deviceToken;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Remover registro de token de dispositivo
  static Future<bool> unregisterDeviceToken(String token) async {
    try {
      final request = TokenUnregisterRequestDto(token: token);
      
      final response = await DioClient.delete(
        '/api/v1/device-tokens',
        data: request.toJson(),
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }
}
