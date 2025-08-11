import 'dart:async';

import 'package:app_dopilot/data/enum/task_status.dart';
import 'package:app_dopilot/screen/task/widget/task_app_bar.dart';
import 'package:app_dopilot/widget/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/task/all_task_cubit.dart';
import '../../bloc/task/all_task_state.dart';
import '../../data/model/task.dart';
import '../../util/colors.dart';
import '../../widget/app_floating_action_button.dart';
import 'widget/task_item_full.dart';

/// Tela de Todas as Tarefas integrada com API
///
/// Funcionalidades:
/// - Lista paginada de tarefas
/// - Busca em tempo real
/// - Filtros por status
/// - Pull-to-refresh
/// - Indicadores de carregamento
class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  late TabController _tabController;
  Timer? _debounceTimer;
  String? _searchQuery;
  String? _statusFilter;
  String label = 'Tarefas';
  int totalTasks = 0;
  bool isUpdating = false;
  bool isLoading = false;
  List<Task> tasks = [];
  TaskStatus taskStatus = TaskStatus.completed;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Carregar todas as tarefas ao inicializar
      _loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {}
  }

  void _onSearchChanged(String query) {
    // Cancela o timer anterior se existir
    _debounceTimer?.cancel();

    // Atualiza a query imediatamente para mostrar no UI
    setState(() {
      _searchQuery = query;
    });

    // Cria um novo timer com delay de 500ms
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // Executa a busca apenas após o delay
      _loadTasks();
    });
  }

  void _onTabChanged(int index) {
    // Limpar pesquisa ao trocar de aba
    _searchController.clear();
    _searchQuery = '';

    setState(() {
      if (index == 0) {
        _statusFilter = null;
      } else if (index == 1) {
        _statusFilter = 'PENDING';
      } else if (index == 2) {
        _statusFilter = 'COMPLETED';
      }
    });

    _loadTasks();
  }

  void _loadTasks() {
    context.read<AllTaskCubit>().loadTasks(
      status: _statusFilter,
      title: _searchQuery,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllTaskCubit, AllTaskState>(
      listener: (context, state) {
        if (state is AllTaskLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is AllTaskLoaded) {
          setState(() {
            tasks = state.tasks;
            isLoading = false;
          });
        } else if (state is AllTaskError) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red[600],
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: TaskAppBar(title: 'Todas as Tarefas'),
        backgroundColor: AppColors.backgroundGray,
        body: SafeArea(
          child: Column(
            children: [_buildSearchBar(), _buildTabs(), _buildTasksList()],
          ),
        ),
        floatingActionButton: AppFloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed('/new-task'),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Buscar tarefas...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery != null && _searchQuery!.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primaryPurple,
        labelColor: AppColors.primaryPurple,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(text: 'Todas'),
          Tab(text: 'Pendentes'),
          Tab(text: 'Concluídas'),
        ],
        onTap: _onTabChanged,
      ),
    );
  }

  Widget _buildTasksList() {
    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.task_alt,
                title: 'Nenhuma tarefa encontrada',
                subtitle:
                    'Você ainda não possui tarefas criadas.\nQue tal começar criando uma nova?',
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskItemFull(
                  task: task,
                  isUpdating: isUpdating,
                  onToggle: () {
                    _completeTask(task);
                  },
                  onEdit: () {
                    _editTask(task);
                  },
                  onDelete: () {
                    _deleteTask(task);
                  },
                );
              },
            ),
    );
  }

  void _editTask(Task task) async {
    final result = await Navigator.of(
      context,
    ).pushNamed('/new-task', arguments: {'task': task});

    // Se retornou algum resultado (tarefa foi salva), recarregar a lista
    if (result != null) {
      _loadTasks();
    }
  }

  void _completeTask(Task task) {
    setState(() {
      task.status = TaskStatus.completed;
      task.isCompleted = true;
    });

    // Salvar índice original para restaurar na posição correta
    final originalIndex = tasks.indexOf(task);

    // Remover da lista imediatamente
    setState(() {
      tasks.removeAt(originalIndex);
    });

    // Mostrar SnackBar com ação desfazer
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tarefa "${task.title}" completada',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'DESFAZER',
              textColor: Colors.white,
              onPressed: () {
                // Restaurar tarefa na posição original
                setState(() {
                  tasks.insert(originalIndex, task);
                });
              },
            ),
          ),
        )
        .closed
        .then((reason) {
          // Executar exclusão apenas se foi timeout
          if (reason == SnackBarClosedReason.timeout) {
            context.read<AllTaskCubit>().toggleTaskCompletion(task.id!);
          }
        });
  }

  void _deleteTask(Task task) {
    // Salvar índice original para restaurar na posição correta
    final originalIndex = tasks.indexOf(task);

    // Remover da lista imediatamente
    setState(() {
      tasks.removeAt(originalIndex);
    });

    // Mostrar SnackBar com ação desfazer
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.delete, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tarefa "${task.title}" removida',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'DESFAZER',
              textColor: Colors.white,
              onPressed: () {
                // Restaurar tarefa na posição original
                setState(() {
                  tasks.insert(originalIndex, task);
                });
              },
            ),
          ),
        )
        .closed
        .then((reason) {
          // Executar exclusão apenas se foi timeout
          if (reason == SnackBarClosedReason.timeout) {
            context.read<AllTaskCubit>().deleteTask(task.id!);
          }
        });
  }
}
