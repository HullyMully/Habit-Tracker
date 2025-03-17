import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum HabitType {
  health,
  productivity,
  relationships,
  personal,
}

enum HabitFrequency {
  daily,
  weekly,
  monthly,
}

class Habit {
  final String id;
  final String title;
  final HabitType type;
  final HabitFrequency frequency;
  final TimeOfDay reminderTime;
  final DateTime createdAt;
  final Map<String, bool> completionLog;

  Habit({
    String? id,
    required this.title,
    required this.type,
    required this.frequency,
    required this.reminderTime,
    DateTime? createdAt,
    Map<String, bool>? completionLog,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        completionLog = completionLog ?? {};

  double getCompletionRate() {
    if (completionLog.isEmpty) return 0.0;
    final completed = completionLog.values.where((v) => v).length;
    return completed / completionLog.length;
  }

  Habit copyWith({
    String? title,
    HabitType? type,
    HabitFrequency? frequency,
    TimeOfDay? reminderTime,
    Map<String, bool>? completionLog,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt,
      completionLog: completionLog ?? Map.from(this.completionLog),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.toString(),
      'frequency': frequency.toString(),
      'reminderTime': '${reminderTime.hour}:${reminderTime.minute}',
      'createdAt': createdAt.toIso8601String(),
      'completionLog': completionLog,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    final reminderTimeParts = (json['reminderTime'] as String).split(':');
    return Habit(
      id: json['id'] as String,
      title: json['title'] as String,
      type: HabitType.values.firstWhere(
        (type) => type.toString() == json['type'],
      ),
      frequency: HabitFrequency.values.firstWhere(
        (freq) => freq.toString() == json['frequency'],
      ),
      reminderTime: TimeOfDay(
        hour: int.parse(reminderTimeParts[0]),
        minute: int.parse(reminderTimeParts[1]),
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completionLog: Map<String, bool>.from(json['completionLog'] as Map),
    );
  }
} 