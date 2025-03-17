import 'package:flutter/material.dart';

class HabitHelper {
  static final Map<String, IconData> habitIcons = {
    // Good habits
    'exercise': Icons.fitness_center,
    'read': Icons.book,
    'meditate': Icons.self_improvement,
    'sleep': Icons.bedtime,
    'water': Icons.water_drop,
    'healthy_food': Icons.restaurant,
    'study': Icons.school,
    'walk': Icons.directions_walk,
    
    // Bad habits
    'smoke': Icons.smoke_free,
    'alcohol': Icons.no_drinks,
    'junk_food': Icons.fastfood,
    'procrastinate': Icons.watch_later,
    'social_media': Icons.phone_android,
    'late_night': Icons.nights_stay,
  };

  static final Map<String, List<String>> habitFacts = {
    'smoke': [
      "Smokers are twice as likely to develop heart disease compared to non-smokers.",
      "Every cigarette smoked reduces life expectancy by 11 minutes.",
      "Quitting smoking can add up to 10 years to your life expectancy!",
      "Within 20 minutes of quitting smoking, your heart rate drops to normal.",
    ],
    'exercise': [
      "Regular exercise can increase your life expectancy by up to 5 years!",
      "Exercise boosts your memory and thinking skills by reducing anxiety and stress.",
      "Just 30 minutes of daily exercise can reduce the risk of heart disease by 30%.",
      "Exercise releases endorphins, nature's mood elevators!",
    ],
    'water': [
      "Drinking enough water can boost your metabolism by up to 30%!",
      "Even mild dehydration can reduce brain function by up to 3%.",
      "Proper hydration can reduce the risk of kidney stones by 39%.",
      "Water helps maintain the balance of body fluids, which is crucial for digestion and circulation.",
    ],
    'sleep': [
      "Lack of sleep can increase the risk of weight gain by 55%.",
      "Regular good sleep can improve problem-solving skills by 50%.",
      "During sleep, your brain processes and consolidates memories from the day.",
      "People who get enough sleep tend to consume 300 fewer calories per day!",
    ],
    'meditate': [
      "Regular meditation can reduce anxiety levels by up to 60%.",
      "Meditation can increase your attention span by 14%.",
      "Just 8 weeks of meditation can measurably change your brain structure.",
      "Meditation practitioners have 15% higher levels of happiness hormones!",
    ],
    'alcohol': [
      "Excessive alcohol consumption can reduce your life expectancy by up to 26 years.",
      "The brain needs 7 days to fully recover from a hangover.",
      "Alcohol can disrupt your sleep cycle for up to 3 days after drinking.",
      "Regular drinking can reduce your brain volume by up to 1.6%.",
    ],
  };

  static String getRandomFact(String habitTitle) {
    final lowercaseTitle = habitTitle.toLowerCase();
    String? key;

    // Find matching key in facts
    for (var k in habitFacts.keys) {
      if (lowercaseTitle.contains(k)) {
        key = k;
        break;
      }
    }

    if (key == null) return '';

    final facts = habitFacts[key]!;
    return facts[DateTime.now().microsecond % facts.length];
  }

  static IconData? findIconForHabit(String habitTitle) {
    final lowercaseTitle = habitTitle.toLowerCase();
    
    // Find matching key in icons
    for (var entry in habitIcons.entries) {
      if (lowercaseTitle.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default icons
    return Icons.check_circle;
  }
} 