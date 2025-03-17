import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habit_model.dart';
import '../services/database_service.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final DatabaseService databaseService;
  final VoidCallback onEdit;

  const HabitCard({
    super.key,
    required this.habit,
    required this.databaseService,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final dateStr = today.toIso8601String().split('T')[0];
    final isCompleted = habit.completionLog[dateStr] ?? false;
    final completionRate = habit.getCompletionRate();

    return Card(
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_getFrequencyLabel(habit.frequency)} в ${habit.reminderTime.format(context)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      databaseService.toggleHabitCompletion(habit.id, today);
                    },
                  ),
                ],
              ),
              if (habit.completionLog.isNotEmpty) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: completionRate,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Выполнено: ${(completionRate * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
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