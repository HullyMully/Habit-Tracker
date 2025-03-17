import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static const String _habitsKey = 'habits';
  static const String _selectedMascotKey = 'selected_mascot';
  final SharedPreferences _prefs;

  DatabaseService(this._prefs);

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habits.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits(
        id TEXT PRIMARY KEY,
        title TEXT,
        type INTEGER,
        frequency INTEGER,
        reminderTime TEXT,
        createdAt TEXT,
        completionLog TEXT,
        icon INTEGER
      )
    ''');
  }

  Future<void> addHabit(Habit habit) async {
    final db = await database;
    await db.insert(
      'habits',
      {
        'id': habit.id,
        'title': habit.title,
        'type': habit.type.index,
        'frequency': habit.frequency.index,
        'reminderTime': habit.reminderTime.toIso8601String(),
        'createdAt': habit.createdAt.toIso8601String(),
        'completionLog': _encodeCompletionLog(habit.completionLog),
        'icon': habit.icon.codePoint,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      'habits',
      {
        'title': habit.title,
        'type': habit.type.index,
        'frequency': habit.frequency.index,
        'reminderTime': habit.reminderTime.toIso8601String(),
        'completionLog': _encodeCompletionLog(habit.completionLog),
        'icon': habit.icon.codePoint,
      },
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> deleteHabit(String id) async {
    final db = await database;
    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) {
      return Habit(
        id: maps[i]['id'],
        title: maps[i]['title'],
        type: HabitType.values[maps[i]['type']],
        frequency: HabitFrequency.values[maps[i]['frequency']],
        reminderTime: DateTime.parse(maps[i]['reminderTime']),
        createdAt: DateTime.parse(maps[i]['createdAt']),
        completionLog: _decodeCompletionLog(maps[i]['completionLog']),
        icon: IconData(maps[i]['icon'] ?? Icons.star.codePoint, fontFamily: 'MaterialIcons'),
      );
    });
  }

  Future<void> updateHabitCompletion(
    String habitId,
    DateTime date,
    bool completed,
  ) async {
    final db = await database;
    final habit = (await getHabits()).firstWhere((h) => h.id == habitId);
    final updatedLog = Map<DateTime, bool>.from(habit.completionLog);
    updatedLog[date] = completed;

    await db.update(
      'habits',
      {'completionLog': _encodeCompletionLog(updatedLog)},
      where: 'id = ?',
      whereArgs: [habitId],
    );
  }

  String _encodeCompletionLog(Map<DateTime, bool> log) {
    return log.map((key, value) => MapEntry(
          key.toIso8601String(),
          value.toString(),
        )).toString();
  }

  Map<DateTime, bool> _decodeCompletionLog(String logString) {
    if (logString.isEmpty) return {};

    final pairs = logString
        .substring(1, logString.length - 1)
        .split(', ')
        .where((e) => e.isNotEmpty)
        .map((e) {
          final parts = e.split(': ');
          return parts.length == 2 ? MapEntry(parts[0], parts[1]) : null;
        })
        .where((e) => e != null)
        .cast<MapEntry<String, String>>();

    return Map.fromEntries(pairs).map((key, value) => MapEntry(
          DateTime.parse(key),
          value.toLowerCase() == 'true',
        ));
  }
} 