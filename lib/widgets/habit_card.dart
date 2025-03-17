import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/assistant_helper.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final AssistantType assistantType;
  final VoidCallback? onEdit;
  final Function(Habit)? onToggleCompletion;

  const HabitCard({
    super.key,
    required this.habit,
    required this.assistantType,
    this.onEdit,
    this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final isCompletedToday = habit.completionLog[todayDate] ?? false;
    final primaryColor = AssistantHelper.primaryColors[assistantType]!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
          ),
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
                          style: GoogleFonts.rubik(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: habit.type == HabitType.good 
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            habit.type == HabitType.good ? 'Good Habit' : 'Bad Habit',
                            style: GoogleFonts.rubik(
                              fontSize: 12,
                              color: habit.type == HabitType.good 
                                ? Colors.green[300]
                                : Colors.red[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isCompletedToday ? Icons.check_circle : Icons.circle_outlined,
                      color: isCompletedToday ? primaryColor : Colors.grey,
                      size: 32,
                    ),
                    onPressed: () {
                      if (onToggleCompletion != null) {
                        final updatedCompletionLog = Map<DateTime, bool>.from(habit.completionLog);
                        updatedCompletionLog[todayDate] = !isCompletedToday;
                        
                        final updatedHabit = habit.copyWith(
                          completionLog: updatedCompletionLog,
                        );
                        onToggleCompletion!(updatedHabit);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Every day at ${habit.reminderTime.hour.toString().padLeft(2, '0')}:${habit.reminderTime.minute.toString().padLeft(2, '0')}',
                    style: GoogleFonts.rubik(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.7,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation(primaryColor),
              ),
              const SizedBox(height: 12),
              Text(
                AssistantHelper.getRandomPhrase(assistantType, habit.type == HabitType.good),
                style: GoogleFonts.rubik(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 