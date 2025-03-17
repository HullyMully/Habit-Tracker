import 'package:flutter/material.dart';
import '../services/assistant_helper.dart';

class AssistantPicker extends StatelessWidget {
  final AssistantType selectedType;
  final ValueChanged<AssistantType> onAssistantChanged;

  const AssistantPicker({
    super.key,
    required this.selectedType,
    required this.onAssistantChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Choose Your Assistant',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: AssistantType.values.length,
            itemBuilder: (context, index) {
              final type = AssistantType.values[index];
              final assistant = AssistantHelper.assistants[type]!;
              final isSelected = type == selectedType;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => onAssistantChanged(type),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? assistant.primaryColor.withOpacity(0.2)
                          : assistant.cardColor,
                      border: Border.all(
                        color: isSelected
                            ? assistant.primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          assistant.emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          assistant.name,
                          style: TextStyle(
                            color: isSelected
                                ? assistant.primaryColor
                                : Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 