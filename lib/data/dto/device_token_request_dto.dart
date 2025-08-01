/// DTO para requisição de registro de token de dispositivo (DeviceTokenRequestDTO)
class DeviceTokenRequestDto {
  final String token;
  final String deviceId;
  final String? deviceModel;
  final String? platform;

  const DeviceTokenRequestDto({
    required this.token,
    required this.deviceId,
    this.deviceModel,
    this.platform,
  });

  /// Converte para Map para envio na API
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'deviceId': deviceId,
      'deviceModel': deviceModel,
      'platform': platform,
    };
  }

  /// Cria DTO a partir de Map
  factory DeviceTokenRequestDto.fromJson(Map<String, dynamic> json) {
    return DeviceTokenRequestDto(
      token: json['token'] ?? '',
      deviceId: json['deviceId'] ?? '',
      deviceModel: json['deviceModel'],
      platform: json['platform'],
    );
  }

  @override
  String toString() {
    return 'DeviceTokenRequestDto(token: ${token.substring(0, 10)}..., deviceId: $deviceId, deviceModel: $deviceModel, platform: $platform)';
  }
}
