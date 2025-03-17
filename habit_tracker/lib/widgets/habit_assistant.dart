import 'package:flutter/material.dart';
import '../services/assistant_helper.dart';
import '../services/habit_helper.dart';

class HabitAssistant extends StatelessWidget {
  final String? habitTitle;
  final bool isGood;
  final AssistantType assistantType;

  const HabitAssistant({
    super.key,
    this.habitTitle,
    required this.isGood,
    required this.assistantType,
  });

  @override
  Widget build(BuildContext context) {
    final assistant = AssistantHelper.assistants[assistantType]!;
    final message = AssistantHelper.getRandomPhrase(
      assistantType,
      habitTitle,
      habitTitle != null ? isGood : null,
    );

    return Card(
      color: assistant.cardColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: assistant.secondaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  assistant.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assistant.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: assistant.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 