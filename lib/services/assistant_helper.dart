import 'package:flutter/material.dart';

enum AssistantType { panda, cat, fox }

class AssistantHelper {
  static const Map<AssistantType, String> emojis = {
    AssistantType.panda: '🐼',
    AssistantType.cat: '🐱',
    AssistantType.fox: '🦊',
  };

  static const Map<AssistantType, String> names = {
    AssistantType.panda: 'Happy Panda',
    AssistantType.cat: 'Cool Cat',
    AssistantType.fox: 'Smart Fox',
  };

  static const Map<AssistantType, Color> primaryColors = {
    AssistantType.panda: Color(0xFF4CAF50), // Green
    AssistantType.cat: Color(0xFF9C27B0), // Purple
    AssistantType.fox: Color(0xFFFF5722), // Orange
  };

  static const Map<AssistantType, List<String>> goodHabitPhrases = {
    AssistantType.panda: [
      'Great job! Keep going! 🎋',
      'You\'re doing amazing! 🌱',
      'Stay positive and grow! 🌿'
    ],
    AssistantType.cat: [
      'Purrfect progress! 🐾',
      'You\'re on fire! Keep it up! ✨',
      'Meow-velous work! 🌙'
    ],
    AssistantType.fox: [
      'Clever choice! Keep it up! 🍂',
      'You\'re getting wiser! 🌟',
      'Fantastic progress! 🌳'
    ],
  };

  static const Map<AssistantType, List<String>> badHabitPhrases = {
    AssistantType.panda: [
      'Stay strong! You can resist! 💪',
      'Remember your goals! 🎯',
      'Every "no" is a victory! 🌟'
    ],
    AssistantType.cat: [
      'Not today! Stay cool! 😎',
      'You\'re stronger than this! ⭐',
      'Keep your whiskers up! 🌙'
    ],
    AssistantType.fox: [
      'Outsmart this habit! 🦊',
      'You\'re too clever for this! 🎯',
      'Use your wisdom! ⚡'
    ],
  };

  static const Map<AssistantType, String> welcomeMessages = {
    AssistantType.panda: 'Hi! I\'m your Panda friend! Let\'s build some awesome habits together! 🎋',
    AssistantType.cat: 'Meow! Ready to make some purrfect habits? Let\'s get started! 🐾',
    AssistantType.fox: 'Hello! I\'ll help you develop smart habits with my clever tricks! 🦊',
  };

  static String getRandomPhrase(AssistantType type, bool isGoodHabit) {
    final phrases = isGoodHabit ? goodHabitPhrases[type]! : badHabitPhrases[type]!;
    return phrases[DateTime.now().millisecondsSinceEpoch % phrases.length];
  }

  static String getWelcomeMessage(AssistantType type) {
    return welcomeMessages[type]!;
  }
} 