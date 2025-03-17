import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/database_service.dart';

class HabitFormScreen extends StatefulWidget {
  final DatabaseService databaseService;
  final Habit? habit;

  const HabitFormScreen({
    super.key,
    required this.databaseService,
    this.habit,
  });

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  late HabitType _type;
  late HabitFrequency _frequency;
  late TimeOfDay _reminderTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _type = widget.habit?.type ?? HabitType.health;
    _frequency = widget.habit?.frequency ?? HabitFrequency.daily;
    _reminderTime = widget.habit?.reminderTime ?? const TimeOfDay(hour: 9, minute: 0);
    
    if (widget.habit != null) {
      _titleController.text = widget.habit!.title;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final habit = Habit(
        id: widget.habit?.id,
        title: _titleController.text,
        type: _type,
        frequency: _frequency,
        reminderTime: _reminderTime,
        createdAt: widget.habit?.createdAt,
        completionLog: widget.habit?.completionLog,
      );

      await widget.databaseService.saveHabit(habit);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteHabit() async {
    if (widget.habit == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить привычку?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);

    try {
      await widget.databaseService.deleteHabit(widget.habit!.id);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка удаления: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'Новая привычка' : 'Редактировать привычку'),
        actions: [
          if (widget.habit != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isLoading ? null : _deleteHabit,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Название',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите название';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<HabitType>(
                    value: _type,
                    decoration: const InputDecoration(
                      labelText: 'Категория',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: HabitType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getHabitTypeLabel(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _type = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<HabitFrequency>(
                    value: _frequency,
                    decoration: const InputDecoration(
                      labelText: 'Частота',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.repeat),
                    ),
                    items: HabitFrequency.values.map((frequency) {
                      return DropdownMenuItem(
                        value: frequency,
                        child: Text(_getFrequencyLabel(frequency)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _frequency = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Время напоминания'),
                    subtitle: Text(_reminderTime.format(context)),
                    leading: const Icon(Icons.access_time),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _reminderTime,
                      );
                      if (time != null) {
                        setState(() => _reminderTime = time);
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _saveHabit,
                    icon: const Icon(Icons.save),
                    label: const Text('Сохранить'),
                  ),
                ],
              ),
            ),
    );
  }

  String _getHabitTypeLabel(HabitType type) {
    switch (type) {
      case HabitType.health:
        return 'Здоровье';
      case HabitType.productivity:
        return 'Продуктивность';
      case HabitType.relationships:
        return 'Отношения';
      case HabitType.personal:
        return 'Личное';
    }
  }

  String _getFrequencyLabel(HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.daily:
        return 'Ежедневно';
      case HabitFrequency.weekly:
        return 'Еженедельно';
      case HabitFrequency.monthly:
        return 'Ежемесячно';
    }
  }
} 