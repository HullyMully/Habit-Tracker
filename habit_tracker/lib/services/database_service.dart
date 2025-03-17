import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/habit_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  static const String _habitsKey = 'habits';
  static const String _selectedMascotKey = 'selected_mascot';
  final SharedPreferences _prefs;

  DatabaseService(this._prefs);

  Future<List<Habit>> getHabits() async {
    final habitsJson = _prefs.getStringList(_habitsKey) ?? [];
    return habitsJson
        .map((json) => Habit.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveHabit(Habit habit) async {
    final habits = await getHabits();
    final existingIndex = habits.indexWhere((h) => h.id == habit.id);
    
    if (existingIndex >= 0) {
      habits[existingIndex] = habit;
    } else {
      habits.add(habit);
    }

    await _saveHabits(habits);
  }

  Future<void> deleteHabit(String id) async {
    final habits = await getHabits();
    habits.removeWhere((habit) => habit.id == id);
    await _saveHabits(habits);
  }

  Future<void> _saveHabits(List<Habit> habits) async {
    final habitsJson = habits
        .map((habit) => jsonEncode(habit.toJson()))
        .toList();
    await _prefs.setStringList(_habitsKey, habitsJson);
  }

  Future<void> toggleHabitCompletion(String id, DateTime date) async {
    final habits = await getHabits();
    final habitIndex = habits.indexWhere((h) => h.id == id);
    
    if (habitIndex >= 0) {
      final habit = habits[habitIndex];
      final dateStr = date.toIso8601String().split('T')[0];
      
      final completionLog = Map<String, bool>.from(habit.completionLog);
      completionLog[dateStr] = !(completionLog[dateStr] ?? false);
      
      habits[habitIndex] = habit.copyWith(completionLog: completionLog);
      await _saveHabits(habits);
    }
  }

  // Mascot preferences
  Future<String?> getSelectedMascot() async {
    return _prefs.getString(_selectedMascotKey);
  }

  Future<void> setSelectedMascot(String mascotType) async {
    await _prefs.setString(_selectedMascotKey, mascotType);
  }
} 