import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/habit_model.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import 'package:provider/provider.dart';

class HabitFormScreen extends StatefulWidget {
  final Habit? habit;

  const HabitFormScreen({Key? key, this.habit}) : super(key: key);

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final DatabaseService _databaseService;
  final _notificationService = NotificationService.instance;
  
  late TextEditingController _titleController;
  late HabitType _type;
  late HabitFrequency _frequency;
  late TimeOfDay _reminderTime;

  @override
  void initState() {
    super.initState();
    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    _titleController = TextEditingController(text: widget.habit?.title);
    _type = widget.habit?.type ?? HabitType.good;
    _frequency = widget.habit?.frequency ?? HabitFrequency.daily;
    _reminderTime = TimeOfDay.fromDateTime(
      widget.habit?.reminderTime ?? DateTime.now(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'New Habit' : 'Edit Habit'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                hintText: 'Example: Drink water, Exercise',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTypeSelector(theme),
            const SizedBox(height: 16),
            _buildFrequencySelector(theme),
            const SizedBox(height: 16),
            _buildReminderTime(theme),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _saveHabit,
              icon: const Icon(Icons.save),
              label: Text(
                widget.habit == null ? 'Create Habit' : 'Save Changes',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            if (widget.habit != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _deleteHabit,
                icon: const Icon(Icons.delete),
                label: const Text('Delete Habit'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Habit Type',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<HabitType>(
          segments: const [
            ButtonSegment<HabitType>(
              value: HabitType.good,
              label: Text('Good'),
              icon: Icon(Icons.thumb_up),
            ),
            ButtonSegment<HabitType>(
              value: HabitType.bad,
              label: Text('Bad'),
              icon: Icon(Icons.thumb_down),
            ),
          ],
          selected: {_type},
          onSelectionChanged: (Set<HabitType> selected) {
            setState(() {
              _type = selected.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFrequencySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Частота выполнения',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<HabitFrequency>(
          value: _frequency,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today),
          ),
          items: [
            DropdownMenuItem(
              value: HabitFrequency.daily,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  const Text('Ежедневно'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: HabitFrequency.weekly,
              child: Row(
                children: [
                  const Icon(Icons.calendar_view_week),
                  const SizedBox(width: 8),
                  const Text('Еженедельно'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: HabitFrequency.monthly,
              child: Row(
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(width: 8),
                  const Text('Ежемесячно'),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _frequency = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildReminderTime(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Время напоминания',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: Text(
            'Напомнить в ${_reminderTime.format(context)}',
            style: theme.textTheme.bodyLarge,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: theme.colorScheme.outline,
            ),
          ),
          onTap: _selectTime,
        ),
      ],
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final now = DateTime.now();
      final reminderDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _reminderTime.hour,
        _reminderTime.minute,
      );

      final habit = Habit(
        id: widget.habit?.id ?? const Uuid().v4(),
        title: _titleController.text,
        type: _type,
        frequency: _frequency,
        reminderTime: reminderDateTime,
        createdAt: widget.habit?.createdAt ?? now,
        completionLog: widget.habit?.completionLog ?? {},
      );

      if (widget.habit == null) {
        await _databaseService.addHabit(habit);
      } else {
        await _databaseService.updateHabit(habit);
      }

      // Настройка уведомления
      await _notificationService.scheduleHabitReminder(
        id: habit.id.hashCode,
        title: habit.title,
        scheduledDate: habit.reminderTime,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
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
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _databaseService.deleteHabit(widget.habit!.id);
      await _notificationService.cancelHabitReminder(widget.habit!.id.hashCode);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }
} 