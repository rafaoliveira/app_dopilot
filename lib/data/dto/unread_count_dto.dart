/// DTO para contagem de notificações não lidas (UnreadCountDTO)
class UnreadCountDto {
  final int unreadCount;

  const UnreadCountDto({
    required this.unreadCount,
  });

  /// Cria DTO a partir da resposta da API
  factory UnreadCountDto.fromJson(Map<String, dynamic> json) {
    return UnreadCountDto(
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  /// Converte para Map
  Map<String, dynamic> toJson() {
    return {
      'unreadCount': unreadCount,
    };
  }

  @override
  String toString() {
    return 'UnreadCountDto(unreadCount: $unreadCount)';
  }
}
