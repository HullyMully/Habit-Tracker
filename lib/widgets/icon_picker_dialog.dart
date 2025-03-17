import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/assistant_helper.dart';

class IconPickerDialog extends StatelessWidget {
  final AssistantType assistantType;

  const IconPickerDialog({
    super.key,
    required this.assistantType,
  });

  static const List<IconData> _icons = [
    Icons.fitness_center,
    Icons.self_improvement,
    Icons.book,
    Icons.water_drop,
    Icons.bed,
    Icons.restaurant,
    Icons.smoking_rooms,
    Icons.phone_android,
    Icons.sports_esports,
    Icons.shopping_cart,
    FontAwesomeIcons.dumbbell,
    FontAwesomeIcons.personRunning,
    FontAwesomeIcons.bookOpen,
    FontAwesomeIcons.droplet,
    FontAwesomeIcons.bed,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.smoking,
    FontAwesomeIcons.mobile,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.cartShopping,
  ];

  Color _getBackgroundColor(AssistantType type) {
    switch (type) {
      case AssistantType.panda:
        return const Color(0xFF4CAF50).withOpacity(0.15);
      case AssistantType.cat:
        return const Color(0xFF9C27B0).withOpacity(0.15);
      case AssistantType.fox:
        return const Color(0xFFFF5722).withOpacity(0.15);
    }
  }

  Color _getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor(assistantType);
    final textColor = _getTextColor(backgroundColor);
    final primaryColor = AssistantHelper.primaryColors[assistantType]!;

    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Icon',
              style: GoogleFonts.rubik(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: _icons.length,
              itemBuilder: (context, index) {
                final icon = _icons[index];
                return InkWell(
                  onTap: () => Navigator.pop(context, icon),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: primaryColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 