import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/assistant_helper.dart';
import '../widgets/habit_assistant.dart';
import '../widgets/assistant_picker.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> _habits = [];
  String _filterType = 'all';
  Habit? _selectedHabit;
  AssistantType _assistantType = AssistantType.owl;

  Future<void> _addHabit() async {
    final habit = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (context) => AddHabitScreen(
          assistantType: _assistantType,
        ),
      ),
    );

    if (habit != null) {
      setState(() {
        _habits.add(habit);
        _selectedHabit = habit;
      });
    }
  }

  List<Habit> get _filteredHabits {
    if (_filterType == 'good') {
      return _habits.where((habit) => habit.isGood).toList();
    } else if (_filterType == 'bad') {
      return _habits.where((habit) => !habit.isGood).toList();
    }
    return _habits;
  }

  void _toggleHabit(Habit habit) {
    setState(() {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        final updatedHabit = Habit(
          id: habit.id,
          title: habit.title,
          isGood: habit.isGood,
          reminderTime: habit.reminderTime,
          frequency: habit.frequency,
          completedDates: [...habit.completedDates],
        );

        if (updatedHabit.completedDates.any((date) =>
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day)) {
          updatedHabit.completedDates.removeWhere((date) =>
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day);
        } else {
          updatedHabit.completedDates.add(today);
        }

        _habits[index] = updatedHabit;
      }
    });
  }

  void _showAssistantPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: AssistantPicker(
          selectedType: _assistantType,
          onAssistantChanged: (type) {
            setState(() {
              _assistantType = type;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assistant = AssistantHelper.assistants[_assistantType]!;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: assistant.primaryColor,
              secondary: assistant.secondaryColor,
            ),
        scaffoldBackgroundColor: assistant.backgroundColor,
        cardTheme: CardTheme(
          color: assistant.cardColor,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Habit Tracker'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Text(
                assistant.emoji,
                style: const TextStyle(fontSize: 24),
              ),
              onPressed: _showAssistantPicker,
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  _filterType = value;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'all',
                  child: Text('All Habits'),
                ),
                const PopupMenuItem(
                  value: 'good',
                  child: Text('Good Habits'),
                ),
                const PopupMenuItem(
                  value: 'bad',
                  child: Text('Bad Habits'),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: HabitAssistant(
                habitTitle: _selectedHabit?.title,
                isGood: _selectedHabit?.isGood ?? true,
                assistantType: _assistantType,
              ),
            ),
            Expanded(
              child: _habits.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.track_changes,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No habits yet',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first habit to start tracking',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredHabits.length,
                      itemBuilder: (context, index) {
                        final habit = _filteredHabits[index];
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        final isCompletedToday = habit.completedDates.any((date) =>
                            date.year == today.year &&
                            date.month == today.month &&
                            date.day == today.day);

                        return Card(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedHabit = habit;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        habit.isGood
                                            ? Icons.thumb_up
                                            : Icons.thumb_down,
                                        color: habit.isGood
                                            ? Colors.green
                                            : Colors.red,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              habit.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            Text(
                                              'Reminder: ${habit.reminderTime.hour}:${habit.reminderTime.minute.toString().padLeft(2, '0')}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isCompletedToday
                                              ? Icons.check_circle
                                              : Icons.check_circle_outline,
                                          color: isCompletedToday
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        onPressed: () => _toggleHabit(habit),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: habit.isGood
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      habit.frequency.toUpperCase(),
                                      style: TextStyle(
                                        color: habit.isGood
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
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
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _addHabit,
          icon: const Icon(Icons.add),
          label: const Text('Add Habit'),
        ),
      ),
    );
  }
} 