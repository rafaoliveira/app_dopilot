import '../data/dto/task_response_dto.dart';
import '../data/model/task_data.dart';
import '../data/model/task_status.dart';
import '../repository/task_repository.dart';

/// Service responsável pela lógica de negócio das tarefas
///
/// Atua como uma camada intermediária entre o Cubit e o Repository,
/// contendo toda a lógica de transformação de dados e regras de negócio
class TaskService {

  late final TaskRepository _taskRepository;


  TaskService() {
    _taskRepository = TaskRepository();
  }

  /// Buscar tarefas do dia atual formatadas para exibição na home
  ///
  /// Retorna uma lista de TaskData já formatada e ordenada
  Future<List<TaskData>> getDailyTasksForHome(DateTime date) async {
    try {
      // Buscar dados do repository
      final tasks = await _taskRepository.getDailyTasksForHome(date);

      // Converter para TaskData e ordenar
      final taskDataList = tasks
          .map((dto) => _convertToTaskData(dto))
          .toList();

      // Ordenar por horário
      taskDataList.sort((a, b) => a.time.compareTo(b.time));

      return taskDataList;
    } catch (e) {
      throw Exception('Erro ao carregar tarefas do dia: $e');
    }
  }

  /// Alternar status de conclusão de uma tarefa
  ///
  /// Retorna TaskData atualizada ou null em caso de erro
  Future<TaskData?> toggleTaskCompletion(int taskId, bool completed) async {
    try {
      final updatedDto = await _taskRepository.toggleTaskCompletion(taskId, completed);

      if (updatedDto != null) {
        return _convertToTaskData(updatedDto);
      }

      return null;
    } catch (e) {
      throw Exception('Erro ao atualizar status da tarefa: $e');
    }
  }

  /// Buscar tarefas do dia com todos os status
  Future<List<TaskData>> getDailyTasks(DateTime date) async {
    try {
      final tasks = await _taskRepository.getDailyTasks(date);

      final taskDataList = tasks
          .map((dto) => _convertToTaskData(dto))
          .toList();

      // Ordenar por horário
      taskDataList.sort((a, b) => a.time.compareTo(b.time));

      return taskDataList;
    } catch (e) {
      throw Exception('Erro ao carregar tarefas: $e');
    }
  }

  /// Obter estatísticas das tarefas
  Future<Map<String, int>> getTaskStats() async {
    try {
      final stats = await _taskRepository.getTaskStats();

      if (stats != null) {
        return {
          'total': stats['total'] ?? 0,
          'completed': stats['completed'] ?? 0,
          'pending': stats['pending'] ?? 0,
          'active': stats['active'] ?? 0,
        };
      }

      return {'total': 0, 'completed': 0, 'pending': 0, 'active': 0};
    } catch (e) {
      throw Exception('Erro ao carregar estatísticas: $e');
    }
  }

  /// Calcular estatísticas de uma lista de tarefas
  Map<String, int> calculateStatsFromTasks(List<TaskData> tasks) {
    final completed = tasks.where((t) => t.isCompleted).length;
    final pending = tasks.length - completed;

    return {
      'total': tasks.length,
      'completed': completed,
      'pending': pending,
    };
  }

  /// Converter TaskResponseDto para TaskData
  TaskData _convertToTaskData(TaskResponseDto dto) {
    return TaskData(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      time: _formatTime(dto.dueDate),
      date: dto.dueDate,
      isCompleted: dto.status == TaskStatus.completed,
      // TODO: Mapear priority e category quando disponíveis no DTO
    );
  }

  /// Formatar horário para exibição (HH:mm)
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

