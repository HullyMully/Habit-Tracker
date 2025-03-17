import '../models/habit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._();
  static FirebaseService get instance => _instance;
  final String _habitsKey = 'habits';
  
  FirebaseService._();

  Future<void> addHabit(Habit habit) async {
    final prefs = await SharedPreferences.getInstance();
    final habits = await getHabits();
    habits.add(habit);
    await prefs.setString(_habitsKey, jsonEncode(
      habits.map((h) => h.toMap()).toList(),
    ));
  }

  Future<void> updateHabit(Habit habit) async {
    final prefs = await SharedPreferences.getInstance();
    final habits = await getHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      await prefs.setString(_habitsKey, jsonEncode(
        habits.map((h) => h.toMap()).toList(),
      ));
    }
  }

  Future<void> deleteHabit(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final habits = await getHabits();
    habits.removeWhere((h) => h.id == id);
    await prefs.setString(_habitsKey, jsonEncode(
      habits.map((h) => h.toMap()).toList(),
    ));
  }

  Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString(_habitsKey);
    if (habitsJson == null) return [];
    
    final habitsList = jsonDecode(habitsJson) as List;
    return habitsList
        .map((json) => Habit.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateHabitCompletion(
    String habitId,
    DateTime date,
    bool completed,
  ) async {
    final habits = await getHabits();
    final habit = habits.firstWhere((h) => h.id == habitId);
    final updatedHabit = habit.copyWith(
      completionLog: Map<DateTime, bool>.from(habit.completionLog)
        ..[date] = completed,
    );
    await updateHabit(updatedHabit);
  }
} 