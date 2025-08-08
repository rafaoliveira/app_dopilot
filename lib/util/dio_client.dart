import 'dart:async';

import 'package:app_dopilot/service/auth_service.dart';
import 'package:dio/dio.dart';

import '../data/dto/api_response_dto.dart';

/// Cliente HTTP usando Dio para requisições da API
///
/// Centraliza configurações de rede, interceptadores e tratamento de erros
class DioClient {
  static DioClient? _instance;
  static Dio? _dio;
  static const String _baseUrl = 'https://ms-dopilot-v1.onrender.com/dopilot'; // API DOPilot
  static const int _connectTimeoutMs = 15000; // 15 segundos
  static const int _receiveTimeoutMs = 15000; // 15 segundos
  AuthService? _authService;

  DioClient._();

  /// Inicializar o DioClient com AuthService
  static void initialize(AuthService authService) {
    if (_instance == null) {
      _instance = DioClient._();
      _instance!._authService = authService;
      _instance!._initializeDio();
    }
  }

  /// Obter instância do DioClient (deve ser inicializado primeiro)
  static DioClient get instance {
    if (_instance == null) {
      throw StateError(
        'DioClient não foi inicializado. Chame DioClient.initialize(authService) primeiro.'
      );
    }
    return _instance!;
  }

  /// Inicializar o Dio
  void _initializeDio() {
    try {
      _dio = Dio();

      // Configurações base
      _dio!.options.baseUrl = _baseUrl;
      _dio!.options.connectTimeout = const Duration(milliseconds: _connectTimeoutMs);
      _dio!.options.receiveTimeout = const Duration(milliseconds: _receiveTimeoutMs);
      _dio!.options.sendTimeout = const Duration(milliseconds: _connectTimeoutMs);

      // Headers padrão
      _dio!.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Adicionar interceptadores
      _addInterceptors();

      print('DioClient inicializado com base URL: $_baseUrl');

    } catch (e) {
      print('Erro ao inicializar DioClient: $e');
    }
  }

  /// Adicionar interceptadores
  void _addInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {

          try {
            if (_authService != null) {
              final token = await _authService!.getValidToken();

              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            }
          } catch (e) {
            print('Erro ao adicionar token: $e');
          }

          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              if (_authService != null) {
                final newToken = await _authService!.getValidToken();

                if (newToken != null) {
                  final retryRequest = error.requestOptions;

                  retryRequest.headers['Authorization'] = 'Bearer $newToken';

                  final response = await _dio!.fetch(retryRequest);
                  return handler.resolve(response);
                } else {
                  // Sessão inválida ou expirada
                  print('Token inválido. Redirecionar para login.');
                  // Aqui você pode disparar uma ação (ex: AuthBloc, Provider, Navigator)
                }
              }
            } catch (e) {
              print('Erro ao tentar renovar o token: $e');
            }
          }

          return handler.next(error);
        },
      ),
    );

    _dio!.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  /// Verificar se o Dio está inicializado
  static void _ensureInitialized() {
    if (_dio == null) {
      throw StateError(
        'DioClient não foi inicializado. Chame DioClient.initialize(authService) primeiro.'
      );
    }
  }

  /// Realizar requisição GET
  static Future<ApiResponseDto<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    _ensureInitialized();

    try {
      final response = await _dio!.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponseDto<T>.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        statusCode: response.statusCode ?? 200,
        message: 'Success',
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponseDto<T>.error(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  /// Realizar requisição POST
  static Future<ApiResponseDto<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponseDto<T>.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        statusCode: response.statusCode ?? 200,
        message: 'Success',
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponseDto<T>.error(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  /// Realizar requisição PUT
  static Future<ApiResponseDto<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    _ensureInitialized();

    try {
      final response = await _dio!.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponseDto<T>.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        statusCode: response.statusCode ?? 200,
        message: 'Success',
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponseDto<T>.error(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  /// Realizar requisição DELETE
  static Future<ApiResponseDto<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    _ensureInitialized();

    try {
      final response = await _dio!.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponseDto<T>.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        statusCode: response.statusCode ?? 200,
        message: 'Success',
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponseDto<T>.error(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  /// Realizar requisição PATCH
  static Future<ApiResponseDto<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    _ensureInitialized();

    try {
      final response = await _dio!.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponseDto<T>.success(
        data: fromJson != null ? fromJson(response.data) : response.data,
        statusCode: response.statusCode ?? 200,
        message: 'Success',
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponseDto<T>.error(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  /// Tratar erros do Dio
  static ApiResponseDto<T> _handleDioError<T>(DioException error) {
    String message;
    int statusCode = error.response?.statusCode ?? 500;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Tempo limite de conexão esgotado';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Tempo limite de envio esgotado';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Tempo limite de recebimento esgotado';
        break;
      case DioExceptionType.badResponse:
        message = _getErrorMessageFromResponse(error.response);
        break;
      case DioExceptionType.cancel:
        message = 'Requisição cancelada';
        break;
      case DioExceptionType.connectionError:
        message = 'Erro de conexão. Verifique sua internet.';
        break;
      case DioExceptionType.badCertificate:
        message = 'Certificado SSL inválido';
        break;
      case DioExceptionType.unknown:
        message = 'Erro desconhecido: ${error.message}';
        break;
    }

    return ApiResponseDto<T>.error(
      message: message,
      statusCode: statusCode,
    );
  }

  /// Extrair mensagem de erro da resposta
  static String _getErrorMessageFromResponse(Response? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;

      // Tentar extrair mensagem de erro de diferentes formatos
      if (data.containsKey('message')) {
        return data['message'].toString();
      } else if (data.containsKey('error')) {
        if (data['error'] is String) {
          return data['error'];
        } else if (data['error'] is Map && data['error']['message'] != null) {
          return data['error']['message'].toString();
        }
      } else if (data.containsKey('errors')) {
        if (data['errors'] is List && (data['errors'] as List).isNotEmpty) {
          return (data['errors'] as List).first.toString();
        }
      }
    }

    // Mensagens padrão baseadas no status code
    switch (response?.statusCode) {
      case 400:
        return 'Dados inválidos';
      case 401:
        return 'Não autorizado. Faça login novamente.';
      case 403:
        return 'Acesso negado';
      case 404:
        return 'Recurso não encontrado';
      case 409:
        return 'Conflito de dados';
      case 422:
        return 'Dados não processáveis';
      case 429:
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 500:
        return 'Erro interno do servidor';
      case 502:
        return 'Servidor indisponível';
      case 503:
        return 'Serviço temporariamente indisponível';
      default:
        return 'Erro na requisição (${response?.statusCode})';
    }
  }

  /// Cancelar todas as requisições
  static void cancelAll() {
    if (_dio != null) {
      _dio!.close();
    }
  }

}
