
/// Classe de resposta da API
class ApiResponseDto<T> {
  final bool success;
  final T? data;
  final String message;
  final int statusCode;

  ApiResponseDto._({
    required this.success,
    this.data,
    required this.message,
    required this.statusCode,
  });

  factory ApiResponseDto.success({
    required T data,
    required int statusCode,
    required String message,
  }) {
    return ApiResponseDto._(
      success: true,
      data: data,
      statusCode: statusCode,
      message: message,
    );
  }

  factory ApiResponseDto.error({
    required String message,
    required int statusCode,
  }) {
    return ApiResponseDto._(
      success: false,
      statusCode: statusCode,
      message: message,
    );
  }

  /// Verificar se a resposta foi bem-sucedida
  bool get isSuccess => success;

  /// Verificar se houve erro
  bool get isError => !success;

  /// Obter dados ou lançar exceção
  T get dataOrThrow {
    if (success && data != null) {
      return data!;
    }
    throw Exception(message);
  }

  @override
  String toString() {
    return 'ApiResponse{success: $success, statusCode: $statusCode, message: $message}';
  }
}
