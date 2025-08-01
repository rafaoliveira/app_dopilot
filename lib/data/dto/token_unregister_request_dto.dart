/// DTO para requisição de desregistro de token (TokenUnregisterRequestDTO)
class TokenUnregisterRequestDto {
  final String token;

  const TokenUnregisterRequestDto({
    required this.token,
  });

  /// Converte para Map para envio na API
  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }

  /// Cria DTO a partir de Map
  factory TokenUnregisterRequestDto.fromJson(Map<String, dynamic> json) {
    return TokenUnregisterRequestDto(
      token: json['token'] ?? '',
    );
  }

  @override
  String toString() {
    return 'TokenUnregisterRequestDto(token: ${token.substring(0, 10)}...)';
  }
}
