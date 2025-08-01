import 'task_response_dto.dart';

/// DTO para resposta paginada da API (PageTaskResponseDTO)
class PageTaskResponseDto {
  final int totalPages;
  final int totalElements;
  final int size;
  final List<TaskResponseDto> content;
  final int number;
  final int numberOfElements;
  final bool last;
  final bool first;
  final bool empty;

  const PageTaskResponseDto({
    required this.totalPages,
    required this.totalElements,
    required this.size,
    required this.content,
    required this.number,
    required this.numberOfElements,
    required this.last,
    required this.first,
    required this.empty,
  });

  /// Cria DTO a partir da resposta da API
  factory PageTaskResponseDto.fromJson(Map<String, dynamic> json) {
    return PageTaskResponseDto(
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      size: json['size'] ?? 0,
      content: (json['content'] as List<dynamic>?)
          ?.map((item) => TaskResponseDto.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      number: json['number'] ?? 0,
      numberOfElements: json['numberOfElements'] ?? 0,
      last: json['last'] ?? true,
      first: json['first'] ?? true,
      empty: json['empty'] ?? true,
    );
  }

  /// Converte para Map
  Map<String, dynamic> toJson() {
    return {
      'totalPages': totalPages,
      'totalElements': totalElements,
      'size': size,
      'content': content.map((task) => task.toJson()).toList(),
      'number': number,
      'numberOfElements': numberOfElements,
      'last': last,
      'first': first,
      'empty': empty,
    };
  }

  @override
  String toString() {
    return 'PageTaskResponseDto(totalPages: $totalPages, totalElements: $totalElements, size: $size, contentLength: ${content.length}, number: $number, numberOfElements: $numberOfElements, last: $last, first: $first, empty: $empty)';
  }
}
