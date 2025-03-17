import 'package:flutter/material.dart';
import '../services/predefined_habits.dart';

class PredefinedHabitsGrid extends StatelessWidget {
  final String category;
  final Function(PredefinedHabit) onHabitSelected;

  const PredefinedHabitsGrid({
    super.key,
    required this.category,
    required this.onHabitSelected,
  });

  @override
  Widget build(BuildContext context) {
    final habits = PredefinedHabits.getHabitsByCategory(category);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return Card(
          child: InkWell(
            onTap: () => onHabitSelected(habit),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    habit.icon,
                    size: 32,
                    color: habit.isGood ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    habit.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 