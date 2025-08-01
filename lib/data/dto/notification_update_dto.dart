/// DTO para atualização de notificação (NotificationUpdateDTO)
class NotificationUpdateDto {
  final bool read;

  const NotificationUpdateDto({
    required this.read,
  });

  /// Converte para Map para envio na API
  Map<String, dynamic> toJson() {
    return {
      'read': read,
    };
  }

  /// Cria DTO a partir de Map
  factory NotificationUpdateDto.fromJson(Map<String, dynamic> json) {
    return NotificationUpdateDto(
      read: json['read'] ?? false,
    );
  }

  @override
  String toString() {
    return 'NotificationUpdateDto(read: $read)';
  }
}
