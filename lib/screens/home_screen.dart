import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/assistant_helper.dart';
import '../models/habit_model.dart';
import '../widgets/habit_card.dart';
import '../widgets/speech_bubble.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AssistantType _assistantType = AssistantType.panda;
  List<Habit> _habits = [];

  Color _getBackgroundColor(AssistantType type) {
    switch (type) {
      case AssistantType.panda:
        return const Color(0xFFE8F5E9); // Light Green
      case AssistantType.cat:
        return const Color(0xFFF3E5F5); // Light Purple
      case AssistantType.fox:
        return const Color(0xFFFBE9E7); // Light Orange
    }
  }

  Color _getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = AssistantHelper.primaryColors[_assistantType]!;
    final backgroundColor = _getBackgroundColor(_assistantType);
    final textColor = _getTextColor(backgroundColor);
    final size = MediaQuery.of(context).size;
    
    return Theme(
      data: theme.copyWith(
        textTheme: GoogleFonts.rubikTextTheme(theme.textTheme),
        colorScheme: theme.colorScheme.copyWith(
          primary: primaryColor,
          background: backgroundColor,
          onBackground: textColor,
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            'Habit Tracker',
            style: GoogleFonts.rubik(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Text(
                AssistantHelper.emojis[_assistantType]!,
                style: const TextStyle(fontSize: 24),
              ),
              onPressed: _showAssistantPicker,
            ),
          ],
        ),
        body: _habits.isEmpty
            ? Stack(
                children: [
                  Positioned(
                    top: size.height * 0.15,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          AssistantHelper.emojis[_assistantType]!,
                          style: TextStyle(fontSize: size.width * 0.3),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SpeechBubble(
                          message: AssistantHelper.getWelcomeMessage(_assistantType),
                          backgroundColor: primaryColor.withOpacity(0.1),
                          textColor: textColor,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 32,
                    left: 32,
                    right: 32,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.add),
                      label: Text(
                        'Add Your First Habit',
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => _addHabit(context),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _habits.length,
                itemBuilder: (context, index) {
                  final habit = _habits[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: HabitCard(
                      habit: habit,
                      assistantType: _assistantType,
                      onEdit: () {
                        _editHabit(habit);
                      },
                      onToggleCompletion: (updatedHabit) {
                        setState(() {
                          final index = _habits.indexWhere((h) => h.id == updatedHabit.id);
                          if (index != -1) {
                            _habits[index] = updatedHabit;
                          }
                        });
                      },
                    ),
                  );
                },
              ),
        floatingActionButton: _habits.isNotEmpty
            ? FloatingActionButton(
                onPressed: () => _addHabit(context),
                backgroundColor: primaryColor,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  void _showAssistantPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Your Assistant',
              style: GoogleFonts.rubik(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: AssistantType.values.map((type) {
                final isSelected = type == _assistantType;
                final primaryColor = AssistantHelper.primaryColors[type]!;
                return GestureDetector(
                  onTap: () {
                    setState(() => _assistantType = type);
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? primaryColor : Colors.grey.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          AssistantHelper.emojis[type]!,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AssistantHelper.names[type]!,
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? primaryColor : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _addHabit(BuildContext context) async {
    final habit = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (context) => AddHabitScreen(assistantType: _assistantType),
      ),
    );

    if (habit != null) {
      setState(() {
        _habits.add(habit);
      });
    }
  }

  void _editHabit(Habit habit) async {
    final result = await Navigator.push<Habit>(
      context,
      MaterialPageRoute(
        builder: (context) => AddHabitScreen(
          assistantType: _assistantType,
          habit: habit,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        final index = _habits.indexWhere((h) => h.id == result.id);
        if (index != -1) {
          _habits[index] = result;
        }
      });
    }
  }
} 