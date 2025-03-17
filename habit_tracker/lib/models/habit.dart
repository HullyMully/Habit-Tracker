class Habit {
  final String id;
  final String title;
  final bool isGood;
  final DateTime reminderTime;
  final String frequency;
  final List<DateTime> completedDates;

  Habit({
    required this.id,
    required this.title,
    required this.isGood,
    required this.reminderTime,
    required this.frequency,
    this.completedDates = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isGood': isGood ? 1 : 0,
      'reminderTime': reminderTime.toIso8601String(),
      'frequency': frequency,
      'completedDates': completedDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      isGood: map['isGood'] == 1,
      reminderTime: DateTime.parse(map['reminderTime']),
      frequency: map['frequency'],
      completedDates: (map['completedDates'] as List)
          .map((date) => DateTime.parse(date))
          .toList(),
    );
  }
} 