import 'package:flutter/material.dart';

class PredefinedHabit {
  final String name;
  final IconData icon;
  final bool isGood;
  final String category;

  const PredefinedHabit({
    required this.name,
    required this.icon,
    required this.isGood,
    required this.category,
  });
}

class PredefinedHabits {
  static const List<PredefinedHabit> habits = [
    // Health & Fitness
    PredefinedHabit(
      name: "Exercise",
      icon: Icons.fitness_center,
      isGood: true,
      category: "Health & Fitness",
    ),
    PredefinedHabit(
      name: "Drink Water",
      icon: Icons.water_drop,
      isGood: true,
      category: "Health & Fitness",
    ),
    PredefinedHabit(
      name: "Sleep Early",
      icon: Icons.bedtime,
      isGood: true,
      category: "Health & Fitness",
    ),
    
    // Mind & Soul
    PredefinedHabit(
      name: "Meditate",
      icon: Icons.self_improvement,
      isGood: true,
      category: "Mind & Soul",
    ),
    PredefinedHabit(
      name: "Read Books",
      icon: Icons.book,
      isGood: true,
      category: "Mind & Soul",
    ),
    PredefinedHabit(
      name: "Journal",
      icon: Icons.edit_note,
      isGood: true,
      category: "Mind & Soul",
    ),

    // Productivity
    PredefinedHabit(
      name: "Study",
      icon: Icons.school,
      isGood: true,
      category: "Productivity",
    ),
    PredefinedHabit(
      name: "Plan Day",
      icon: Icons.event_note,
      isGood: true,
      category: "Productivity",
    ),
    PredefinedHabit(
      name: "Learn Language",
      icon: Icons.translate,
      isGood: true,
      category: "Productivity",
    ),

    // Bad Habits
    PredefinedHabit(
      name: "Smoke",
      icon: Icons.smoke_free,
      isGood: false,
      category: "Bad Habits",
    ),
    PredefinedHabit(
      name: "Junk Food",
      icon: Icons.fastfood,
      isGood: false,
      category: "Bad Habits",
    ),
    PredefinedHabit(
      name: "Social Media",
      icon: Icons.phone_android,
      isGood: false,
      category: "Bad Habits",
    ),
    PredefinedHabit(
      name: "Late Night",
      icon: Icons.nights_stay,
      isGood: false,
      category: "Bad Habits",
    ),
  ];

  static List<String> get categories {
    return habits
        .map((habit) => habit.category)
        .toSet()
        .toList();
  }

  static List<PredefinedHabit> getHabitsByCategory(String category) {
    return habits
        .where((habit) => habit.category == category)
        .toList();
  }
} 