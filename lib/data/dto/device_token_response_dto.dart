/// DTO para resposta de registro de token (DeviceTokenResponseDTO)
class DeviceTokenResponseDto {
  final int id;
  final String userId;
  final String token;
  final String deviceId;
  final String? deviceModel;
  final String? platform;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DeviceTokenResponseDto({
    required this.id,
    required this.userId,
    required this.token,
    required this.deviceId,
    this.deviceModel,
    this.platform,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria DTO a partir da resposta da API
  factory DeviceTokenResponseDto.fromJson(Map<String, dynamic> json) {
    return DeviceTokenResponseDto(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      token: json['token'] ?? '',
      deviceId: json['deviceId'] ?? '',
      deviceModel: json['deviceModel'],
      platform: json['platform'],
      active: json['active'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Converte para Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'token': token,
      'deviceId': deviceId,
      'deviceModel': deviceModel,
      'platform': platform,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'DeviceTokenResponseDto(id: $id, userId: $userId, token: ${token.substring(0, 10)}..., deviceId: $deviceId, deviceModel: $deviceModel, platform: $platform, active: $active, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
