/// DTO para resposta de notificação (NotificationResponseDTO)
class NotificationDto {
  final int id;
  final String title;
  final String message;
  final DateTime createdAt;
  final DateTime? readAt;
  final int? taskId;
  final String? taskTitle;
  final bool read;

  const NotificationDto({
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
  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
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
  NotificationDto copyWith({
    int? id,
    String? title,
    String? message,
    DateTime? createdAt,
    DateTime? readAt,
    int? taskId,
    String? taskTitle,
    bool? read,
  }) {
    return NotificationDto(
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
    return 'NotificationDto(id: $id, title: $title, message: $message, createdAt: $createdAt, readAt: $readAt, taskId: $taskId, taskTitle: $taskTitle, read: $read)';
  }
}

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
