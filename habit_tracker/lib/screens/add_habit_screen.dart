import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../services/predefined_habits.dart';
import '../widgets/predefined_habits_grid.dart';
import '../services/assistant_helper.dart';

class AddHabitScreen extends StatefulWidget {
  final AssistantType assistantType;

  const AddHabitScreen({
    super.key,
    required this.assistantType,
  });

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  bool _isGood = true;
  String _frequency = 'daily';
  TimeOfDay _reminderTime = TimeOfDay.now();
  IconData _selectedIcon = Icons.check_circle;
  bool _isCustomHabit = false;

  @override
  void initState() {
    super.initState();
    _loadIcons();
  }

  void _loadIcons() {
    _availableIcons.addAll([
      Icons.fitness_center,
      Icons.book,
      Icons.self_improvement,
      Icons.bedtime,
      Icons.water_drop,
      Icons.restaurant,
      Icons.school,
      Icons.directions_walk,
      Icons.smoke_free,
      Icons.no_drinks,
      Icons.fastfood,
      Icons.watch_later,
      Icons.phone_android,
      Icons.nights_stay,
      Icons.edit_note,
      Icons.event_note,
      Icons.translate,
      Icons.music_note,
      Icons.palette,
      Icons.sports_esports,
    ]);
  }

  final List<IconData> _availableIcons = [];

  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Icon',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _availableIcons.length,
                itemBuilder: (context, index) {
                  final icon = _availableIcons[index];
                  return IconButton(
                    icon: Icon(icon),
                    onPressed: () {
                      setState(() {
                        _selectedIcon = icon;
                      });
                      Navigator.pop(context);
                    },
                    color: _selectedIcon == icon
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectPredefinedHabit(PredefinedHabit habit) {
    setState(() {
      _titleController.text = habit.name;
      _isGood = habit.isGood;
      _selectedIcon = habit.icon;
    });
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

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final reminderDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _reminderTime.hour,
        _reminderTime.minute,
      );

      final habit = Habit(
        id: const Uuid().v4(),
        title: _titleController.text,
        isGood: _isGood,
        reminderTime: reminderDateTime,
        frequency: _frequency,
      );

      Navigator.pop(context, habit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final assistant = AssistantHelper.assistants[widget.assistantType]!;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: assistant.primaryColor,
              secondary: assistant.secondaryColor,
            ),
      ),
      child: Scaffold(
        backgroundColor: assistant.backgroundColor,
        appBar: AppBar(
          title: const Text('Add New Habit'),
          actions: [
            IconButton(
              icon: Icon(
                _isCustomHabit ? Icons.grid_view : Icons.edit,
              ),
              onPressed: () {
                setState(() {
                  _isCustomHabit = !_isCustomHabit;
                });
              },
            ),
          ],
        ),
        body: _isCustomHabit
            ? Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Habit Name',
                        hintText: 'Example: Exercise, Read a book',
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(_selectedIcon),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _showIconPicker,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a habit name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Habit Type',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            SegmentedButton<bool>(
                              segments: const [
                                ButtonSegment(
                                  value: true,
                                  label: Text('Good'),
                                  icon: Icon(Icons.thumb_up),
                                ),
                                ButtonSegment(
                                  value: false,
                                  label: Text('Bad'),
                                  icon: Icon(Icons.thumb_down),
                                ),
                              ],
                              selected: {_isGood},
                              onSelectionChanged: (Set<bool> newSelection) {
                                setState(() {
                                  _isGood = newSelection.first;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Frequency',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _frequency,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'daily',
                                  child: Text('Daily'),
                                ),
                                DropdownMenuItem(
                                  value: 'weekly',
                                  child: Text('Weekly'),
                                ),
                                DropdownMenuItem(
                                  value: 'monthly',
                                  child: Text('Monthly'),
                                ),
                              ],
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    _frequency = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        title: Text(
                          'Reminder Time',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          'Remind at ${_reminderTime.format(context)}',
                        ),
                        trailing: const Icon(Icons.access_time),
                        onTap: _selectTime,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _saveHabit,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Habit'),
                    ),
                  ],
                ),
              )
            : DefaultTabController(
                length: PredefinedHabits.categories.length,
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      tabs: PredefinedHabits.categories
                          .map((category) => Tab(text: category))
                          .toList(),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: PredefinedHabits.categories.map((category) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                PredefinedHabitsGrid(
                                  category: category,
                                  onHabitSelected: (habit) {
                                    _selectPredefinedHabit(habit);
                                    setState(() {
                                      _isCustomHabit = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
} 