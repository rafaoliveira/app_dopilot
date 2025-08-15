import '../data/dto/task_request_dto.dart';
import '../data/dto/task_response_dto.dart';
import '../data/enum/task_status.dart';
import '../util/dio_client.dart';

/// Serviço para gerenciar operações de tarefas com a API DOPilot
/// 
/// Responsável por gerenciar tarefas
///
/// - DELETE /api/v1/tasks/{id} - Excluir uma tarefa
/// - GET /api/v1/tasks/{id} - Obter uma tarefa específica pelo ID
/// - GET /api/v1/tasks - Listar tarefas do usuário com filtros opcionais
/// - POST /api/v1/tasks - Criar uma nova tarefa
/// - PUT /api/v1/tasks/{id} - Atualizar uma tarefa existente
class TaskRepository {

  /// Criar nova tarefa
  /// 
  /// Retorna TaskResponseDto com dados da tarefa criada ou null em caso de erro
  Future<TaskResponseDto?> createTask(TaskRequestDto taskRequest) async {
    try {
      final response = await DioClient.post<Map<String, dynamic>>(
        '/api/v1/tasks',
        data: taskRequest.toJson(),
      );

      if (response.success && response.data != null) {
        final taskResponse = TaskResponseDto.fromJson(response.data!);
        print('Tarefa criada com sucesso: ${taskResponse.id}');
        return taskResponse;
      } else {
        print('Erro ao criar tarefa: Response unsuccessful');
        return null;
      }
    } catch (e) {
      print('Erro na criação de tarefa: $e');
      return null;
    }
  }

  /// Editar tarefa existente
  /// 
  /// Retorna TaskResponseDto com dados atualizados ou null em caso de erro
  Future<TaskResponseDto?> updateTask(int taskId, TaskRequestDto taskRequest) async {

    try {
      final response = await DioClient.put<Map<String, dynamic>>(
        '/api/v1/tasks/$taskId',
        data: taskRequest.toJson(),
      );

      if (response.success && response.data != null) {
        final taskResponse = TaskResponseDto.fromJson(response.data!);
        print('Tarefa atualizada com sucesso: ${taskResponse.id}');
        return taskResponse;
      } else {
        print('Erro ao atualizar tarefa $taskId: Response unsuccessful');
        return null;
      }
    } catch (e) {
      print('Erro na atualização de tarefa: $e');
      return null;
    }
  }

  /// Buscar todas as tarefas do usuário com filtros
  /// 
  /// Agora usa o endpoint unificado com parâmetros de query opcionais
  Future<List<TaskResponseDto>> getUserTasks({
    int? page = 0, // API usa zero-based pagination
    int? size = 10,
    String? title,
    String? sortBy = 'dueDate',
    String? direction = 'asc',
    String? status, // PENDING, IN_PROGRESS, COMPLETED, CANCELLED
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
        'sortBy': sortBy,
        'title': title,
        'direction': direction,
      };

      if (status != null) queryParams['status'] = status;
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0]; // Format: YYYY-MM-DD
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0]; // Format: YYYY-MM-DD
      }

      final response = await DioClient.get<Map<String, dynamic>>(
        '/api/v1/tasks',
        queryParameters: queryParams,
      );

      if (response.success && response.data != null) {
        final Map<String, dynamic> pageData = response.data!;
        final List<dynamic> tasksJson = pageData['content'] ?? [];
        final tasks = tasksJson
            .map((json) => TaskResponseDto.fromJson(json as Map<String, dynamic>))
            .toList();

        print('${tasks.length} tarefas carregadas da API (página $page)');
        return tasks;
      } else {
        print('Erro ao buscar tarefas: Response unsuccessful');
        throw Exception('Erro ao buscar tarefas');
      }
    } catch (e) {
      print('Erro na busca de tarefas: $e');
      rethrow;
    }
  }

  /// Buscar tarefa específica por ID
  /// 
  /// Retorna TaskResponseDto ou null se não encontrada
  Future<TaskResponseDto?> getTaskById(int taskId) async {
    try {
      final response = await DioClient.get<Map<String, dynamic>>(
        '/api/v1/tasks/$taskId',
      );

      if (response.success && response.data != null) {
        final task = TaskResponseDto.fromJson(response.data!);
        print('Tarefa $taskId carregada da API');
        return task;
      } else {
        print('Tarefa $taskId não encontrada ou erro na API');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar tarefa $taskId: $e');
      return null;
    }
  }

  /// Deletar tarefa
  /// 
  /// Retorna true se deletada com sucesso, false caso contrário
  Future<bool> deleteTask(int taskId) async {
    try {
      final response = await DioClient.delete(
        '/api/v1/tasks/$taskId',
      );

      if (response.success) {
        print('Tarefa $taskId deletada com sucesso');
        return true;
      } else {
        print('Erro ao deletar tarefa $taskId: Response unsuccessful');
        return false;
      }
    } catch (e) {
      print('Erro ao deletar tarefa $taskId: $e');
      return false;
    }
  }

  /// Atualizar status de conclusão da tarefa
  /// 
  /// Usa o endpoint PUT padrão para atualizar o status da tarefa
  Future<TaskResponseDto?> toggleTaskCompletion(int taskId, bool completed) async {
    try {
      // Primeiro buscar a tarefa atual para manter outros dados
      final currentTask = await getTaskById(taskId);

      if (currentTask == null) {
        print('Tarefa $taskId não encontrada para atualização');
        return null;
      }

      // Criar TaskRequestDto com status atualizado
      final updatedTaskRequest = TaskRequestDto(
        title: currentTask.title,
        description: currentTask.description,
        dueDate: currentTask.dueDate,
        status: completed ? TaskStatus.completed : TaskStatus.pending,
        priority: currentTask.priority,
        category: currentTask.category,
      );

      final response = await DioClient.put<Map<String, dynamic>>(
        '/api/v1/tasks/$taskId',
        data: updatedTaskRequest.toJson(),
      );

      if (response.success && response.data != null) {
        final task = TaskResponseDto.fromJson(response.data!);
        print('Status da tarefa $taskId atualizado: ${completed ? 'concluída' : 'pendente'}');
        return task;
      } else {
        print('Erro ao atualizar status da tarefa $taskId');
        return null;
      }
    } catch (e) {
      print('Erro ao atualizar status da tarefa $taskId: $e');
      return null;
    }
  }


}