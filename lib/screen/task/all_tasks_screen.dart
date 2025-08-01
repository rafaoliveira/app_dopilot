import 'package:app_dopilot/screen/task/widget/task_app_bar.dart';
import 'package:flutter/material.dart';
import '../../data/model/task_data.dart';
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
  String _searchQuery = '';
  String label = 'Tarefas';
  int totalTasks = 0;
  bool isUpdating = false;
  List<TaskData> tasks = [
    TaskData(title: 'Sample 1', time: '20/07/2025 18:00', isCompleted: false),
    TaskData(title: 'Sample 2', time: '21/07/2025 17:00', isCompleted: false),
    TaskData(title: 'Sample 3', time: '22/07/2025 11:00', isCompleted: true),
    TaskData(title: 'Sample 4', time: '23/07/2025 12:00', isCompleted: false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {}
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onTabChanged(int index) {
    // Limpar pesquisa ao trocar de aba
    _searchController.clear();
    _searchQuery = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(title: 'Todas as Tarefas'),
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildTabs(),
            _buildTasksList(),
          ],
        ),
      ),
      floatingActionButton: AppFloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/new-task'),
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
          suffixIcon: _searchQuery.isNotEmpty
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
      child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          itemCount: tasks.length,
          itemBuilder: (context, index) {

            final task = tasks[index];

            return TaskItemFull(
              task: task,
              isUpdating: isUpdating,
              onToggle: () {

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

  void _editTask(TaskData task) {
  }

  void _deleteTask(TaskData task) {

  }

}
