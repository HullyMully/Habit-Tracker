import 'package:flutter/material.dart';

enum HabitType { good, bad }
enum HabitFrequency { daily, weekly, monthly }

class Habit {
  final String id;
  final String title;
  final HabitType type;
  final HabitFrequency frequency;
  final DateTime reminderTime;
  final DateTime createdAt;
  final Map<DateTime, bool> completionLog;
  final IconData icon;

  const Habit({
    required this.id,
    required this.title,
    required this.type,
    required this.frequency,
    required this.reminderTime,
    required this.createdAt,
    required this.completionLog,
    this.icon = Icons.star,
  });

  double getCompletionRate() {
    if (completionLog.isEmpty) return 0.0;
    int completed = completionLog.values.where((v) => v).length;
    return completed / completionLog.length;
  }

  Habit copyWith({
    String? id,
    String? title,
    HabitType? type,
    HabitFrequency? frequency,
    DateTime? reminderTime,
    DateTime? createdAt,
    Map<DateTime, bool>? completionLog,
    IconData? icon,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      completionLog: completionLog ?? this.completionLog,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.index,
      'frequency': frequency.index,
      'reminderTime': reminderTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'completionLog': completionLog.map(
        (key, value) => MapEntry(key.toIso8601String(), value),
      ).toString(),
      'icon': icon.codePoint,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      type: HabitType.values[map['type']],
      frequency: HabitFrequency.values[map['frequency']],
      reminderTime: DateTime.parse(map['reminderTime']),
      createdAt: DateTime.parse(map['createdAt']),
      completionLog: _decodeCompletionLog(map['completionLog']),
      icon: IconData(map['icon'] ?? Icons.star.codePoint, fontFamily: 'MaterialIcons'),
    );
  }

  static Map<DateTime, bool> _decodeCompletionLog(String logString) {
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