/// DTO para resposta de notificação (NotificationResponseDTO)
class NotificationResponseDto {
  final int id;
  final String title;
  final String message;
  final DateTime createdAt;
  final DateTime? readAt;
  final int? taskId;
  final String? taskTitle;
  final bool read;

  const NotificationResponseDto({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.readAt,
    this.taskId,
    this.taskTitle,
    required this.read,
  });

  /// Cria DTO a partir da resposta da API
  factory NotificationResponseDto.fromJson(Map<String, dynamic> json) {
    return NotificationResponseDto(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      taskId: json['taskId'],
      taskTitle: json['taskTitle'],
      read: json['read'] ?? false,
    );
  }

  /// Converte para Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'taskId': taskId,
      'taskTitle': taskTitle,
      'read': read,
    };
  }

  /// Cria cópia com campos alterados
  NotificationResponseDto copyWith({
    int? id,
    String? title,
    String? message,
    DateTime? createdAt,
    DateTime? readAt,
    int? taskId,
    String? taskTitle,
    bool? read,
  }) {
    return NotificationResponseDto(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      read: read ?? this.read,
    );
  }

  @override
  String toString() {
    return 'NotificationResponseDto(id: $id, title: $title, message: $message, createdAt: $createdAt, readAt: $readAt, taskId: $taskId, taskTitle: $taskTitle, read: $read)';
  }
}
