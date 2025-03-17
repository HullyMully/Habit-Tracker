import 'package:flutter/material.dart';

enum AssistantType {
  owl,
  panda,
  cat,
}

class AssistantTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color cardColor;
  final String emoji;
  final String name;
  final List<String> goodPhrases;
  final List<String> badPhrases;
  final List<String> welcomePhrases;

  const AssistantTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.emoji,
    required this.name,
    required this.goodPhrases,
    required this.badPhrases,
    required this.welcomePhrases,
  });
}

class AssistantHelper {
  static final Map<AssistantType, AssistantTheme> assistants = {
    AssistantType.owl: AssistantTheme(
      primaryColor: const Color(0xFF8B4513),
      secondaryColor: const Color(0xFFD2691E),
      backgroundColor: const Color(0xFF2C1810),
      cardColor: const Color(0xFF3D261C),
      emoji: '🦉',
      name: 'Wise Owl',
      goodPhrases: [
        "Knowledge is power! You're making wise choices.",
        "As we say in the owl community - every small step counts!",
        "You're as wise as an owl, making great decisions!",
        "Hoot hoot! That's a brilliant habit to develop!",
      ],
      badPhrases: [
        "Let's think this through with wisdom...",
        "Even the wisest owls make mistakes, but they learn from them.",
        "Remember, night is for rest, not bad habits.",
        "Together, we can turn this around with wisdom.",
      ],
      welcomePhrases: [
        "Welcome! I'm your wise companion on this journey.",
        "Let's make wise choices together!",
        "Ready to develop some owl-some habits?",
        "Wisdom comes from making good choices every day.",
      ],
    ),
    AssistantType.panda: AssistantTheme(
      primaryColor: const Color(0xFF4CAF50),
      secondaryColor: const Color(0xFF81C784),
      backgroundColor: const Color(0xFF1B1B1B),
      cardColor: const Color(0xFF2D2D2D),
      emoji: '🐼',
      name: 'Happy Panda',
      goodPhrases: [
        "Yay! That's as refreshing as bamboo shoots!",
        "You're doing great! Keep that panda energy!",
        "Rolling with happiness for your good choices!",
        "That's the spirit! Peaceful and positive!",
      ],
      badPhrases: [
        "Even pandas have off days, but we keep trying!",
        "Let's find a better way to spend your energy.",
        "Remember, peace comes from good choices.",
        "Together, we can find better bamboo to chew on!",
      ],
      welcomePhrases: [
        "Hi! I'm your peaceful panda friend!",
        "Ready to roll into some good habits?",
        "Let's make this journey peaceful and fun!",
        "Together, we'll grow like fresh bamboo!",
      ],
    ),
    AssistantType.cat: AssistantTheme(
      primaryColor: const Color(0xFF9C27B0),
      secondaryColor: const Color(0xFFBA68C8),
      backgroundColor: const Color(0xFF1A1A1A),
      cardColor: const Color(0xFF2B2B2B),
      emoji: '🐱',
      name: 'Cool Cat',
      goodPhrases: [
        "Purr-fect choice! You're doing great!",
        "That's the cat's meow! Keep it up!",
        "You're as graceful as a cat with these good habits!",
        "Feline good about your progress!",
      ],
      badPhrases: [
        "Let's scratch that habit off our list.",
        "Even curious cats know better than that!",
        "Time to land on your feet with better choices.",
        "Trust your cat instincts - you know what's right!",
      ],
      welcomePhrases: [
        "Meow! Ready to be purr-fectly productive?",
        "Your cool cat companion is here to help!",
        "Let's make some purr-sitive changes together!",
        "Nine lives of good habits ahead!",
      ],
    ),
  };

  static String getRandomPhrase(AssistantType type, String? habitTitle, bool? isGood) {
    final assistant = assistants[type]!;
    
    if (habitTitle == null || isGood == null) {
      final welcomePhrases = assistant.welcomePhrases;
      return welcomePhrases[DateTime.now().microsecond % welcomePhrases.length];
    }

    final phrases = isGood ? assistant.goodPhrases : assistant.badPhrases;
    return phrases[DateTime.now().microsecond % phrases.length];
  }
} 