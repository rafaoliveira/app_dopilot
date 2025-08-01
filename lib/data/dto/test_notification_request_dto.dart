/// DTO para teste de notificação (TestNotificationRequestDTO)
class TestNotificationRequestDto {
  final String title;
  final String body;

  const TestNotificationRequestDto({
    required this.title,
    required this.body,
  });

  /// Converte para Map para envio na API
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
    };
  }

  /// Cria DTO a partir de Map
  factory TestNotificationRequestDto.fromJson(Map<String, dynamic> json) {
    return TestNotificationRequestDto(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  @override
  String toString() {
    return 'TestNotificationRequestDto(title: $title, body: $body)';
  }
}
