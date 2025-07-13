import 'package:app_dopilot/screens/tasks/widgets/new_task_app_bar.dart';
import 'package:app_dopilot/widgets/app_button.dart';
import 'package:app_dopilot/widgets/app_text.dart';
import 'package:app_dopilot/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import '../../models/task_data.dart';
import '../../models/task_priority.dart';
import '../../models/task_category.dart';
import '../../utils/colors.dart';
import '../../utils/validators.dart';

/// Tela de Nova Tarefa / Editar Tarefa do DoPilot
///
/// Permite criar ou editar uma tarefa com:
/// - Título da tarefa
/// - Descrição detalhada
/// - Data e hora
/// - Prioridade (Alta, Média, Baixa)
/// - Categoria (Trabalho, Pessoal, Saúde, Estudos)
class NewTaskScreen extends StatefulWidget {
  final TaskData? task; // null = nova tarefa, TaskData = editar tarefa

  const NewTaskScreen({super.key, this.task});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TaskPriority? _selectedPriority;
  TaskCategory? _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeWithDefaults();
  }

  void _initializeWithDefaults() {
    _selectedDate = DateTime.now();
    _dateController.text = _formatDate(_selectedDate!);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: NewTaskAppBar(title: 'Nova Tarefa'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitleField(),
                const SizedBox(height: 20),
                _buildDescriptionField(),
                const SizedBox(height: 20),
                _buildDateTimeSection(),
                const SizedBox(height: 20),
                _buildPrioritySection(),
                const SizedBox(height: 20),
                _buildCategorySection(),
                const SizedBox(height: 32),

                AppButton(text: 'Salvar', onPressed: _handleSaveTask,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Título da tarefa'),
        const SizedBox(height: 8),
        AppTextField(
          controller: _titleController,
          label: 'Digite o título da tarefa',
          validator: Validators.validateTaskTitle,
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Descrição'),
        const SizedBox(height: 8),
        AppTextField(
          controller: _descriptionController,
          maxLines: 3,
          label: 'Adicione uma descrição detalhada...',
          validator: Validators.validateTaskDescription,
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Data e hora'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _dateController.text.isEmpty
                              ? 'Selecionar data'
                              : _dateController.text,
                          style: TextStyle(
                            color: _dateController.text.isEmpty
                                ? Colors.grey[400]
                                : Colors.black87,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.primaryPurple,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _selectTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _timeController.text.isEmpty
                              ? 'Selecionar hora'
                              : _timeController.text,
                          style: TextStyle(
                            color: _timeController.text.isEmpty
                                ? Colors.grey[400]
                                : Colors.black87,
                          ),
                        ),
                      ),
                      Icon(Icons.access_time, color: AppColors.primaryPurple),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Prioridade'),
        const SizedBox(height: 12),
        Row(
          children: TaskPriority.values.map((priority) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: priority != TaskPriority.values.last ? 8 : 0,
                ),
                child: _buildPriorityCard(priority),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriorityCard(TaskPriority priority) {
    final isSelected = _selectedPriority == priority;
    Color color;

    switch (priority) {
      case TaskPriority.alta:
        color = const Color(0xFFEF4444);
        break;
      case TaskPriority.media:
        color = const Color(0xFFF59E0B);
        break;
      case TaskPriority.baixa:
        color = const Color(0xFF10B981);
        break;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = isSelected ? null : priority;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 8),
            Text(
              priority.label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Categoria'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: TaskCategory.values.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(TaskCategory.values[index]);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(TaskCategory category) {
    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = isSelected ? null : category;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? category.color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              color: isSelected ? category.color : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              category.label,
              style: TextStyle(
                color: isSelected ? category.color : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryPurple),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateController.text = _formatDate(date);
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryPurple),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
        _timeController.text =
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _handleSaveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.task != null && widget.task!.id != null) {
      // Editar tarefa existente
    } else {
      // Criar nova tarefa
    }
  }

}
